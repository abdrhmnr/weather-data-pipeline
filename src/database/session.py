from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from contextlib import contextmanager
from config.settings import DB_CONFIG

# Construct the database URL from config
db_user = DB_CONFIG['user']
db_password = DB_CONFIG['password']
db_host = DB_CONFIG['host']
db_port = DB_CONFIG['port']
db_name = DB_CONFIG['dbname']

SQLALCHEMY_DATABASE_URL = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

# Create engine with connection pooling enabled
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_size=5,
    max_overflow=10,
    pool_timeout=30,
    pool_recycle=1800,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@contextmanager
def get_db():
    """Provide a transactional scope around a series of operations."""
    db = SessionLocal()
    try:
        yield db
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()
