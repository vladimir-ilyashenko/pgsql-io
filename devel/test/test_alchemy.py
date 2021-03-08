
from sqlalchemy import create_engine

db_string = "postgres://postgres:password@localhost:5432/openrds"

db = create_engine(db_string)

rs = db.execute("SELECT * FROM version()")
for r in rs:
  print(r)




