import os
import time
from urllib.parse import quote_plus

from flask import Flask, render_template
from sqlalchemy import Column, Integer, String, create_engine, select, func, text
from sqlalchemy.exc import OperationalError
from sqlalchemy.orm import declarative_base, Session

app = Flask(__name__)
Base = declarative_base()


class Item(Base):
    __tablename__ = "items"

    id = Column(Integer, primary_key=True)
    name = Column(String(120), nullable=False)
    image_url = Column(String(512), nullable=False)


def database_url() -> str:
    host = os.environ["DATABASE_HOST"]
    port = os.environ.get("DATABASE_PORT", "5432")
    dbname = os.environ["DATABASE_NAME"]
    user = os.environ["DATABASE_USER"]
    password = quote_plus(os.environ["DATABASE_PASSWORD"])
    return f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{dbname}"


def image_base_url() -> str:
    return os.environ.get("IMAGE_BASE_URL", "")


def make_engine():
    return create_engine(database_url(), pool_pre_ping=True, pool_size=5, max_overflow=2)


def wait_for_db(engine, attempts: int = 30, delay_seconds: int = 5):
    last_error = None
    for _ in range(attempts):
        try:
            with engine.connect() as conn:
                conn.execute(text("SELECT 1"))
            return
        except OperationalError as exc:
            last_error = exc
            time.sleep(delay_seconds)
    raise last_error


def seed_if_needed(engine):
    items = [
        ("Classic Glazed", f"{image_base_url()}/donut-1.svg"),
        ("Purple Power", f"{image_base_url()}/donut-2.svg"),
        ("Strawberry Sunset", f"{image_base_url()}/donut-3.svg"),
        ("Mint Wave", f"{image_base_url()}/donut-4.svg"),
    ]

    with Session(engine) as session:
        count = session.scalar(select(func.count()).select_from(Item))
        if count == 0:
            session.add_all([Item(name=name, image_url=url) for name, url in items])
            session.commit()


engine = make_engine()
wait_for_db(engine)
Base.metadata.create_all(engine)
seed_if_needed(engine)


@app.get("/")
def index():
    with Session(engine) as session:
        items = session.scalars(select(Item).order_by(Item.id)).all()
    return render_template("index.html", items=items)


@app.get("/health")
def health():
    return {"status": "ok"}, 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
