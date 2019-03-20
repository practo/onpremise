import re
import sys
import psycopg2 as Database

from django.conf import settings
from django.db import connection
from django.db.utils import OperationalError
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


def create_database(connection_params):
  params = connection_params.copy()
  database = params.pop('database')
  params['database'] = 'postgres'
  conn = Database.connect(**params)
  conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
  cursor = conn.cursor()
  cursor.execute('CREATE DATABASE ' + database)
  cursor.close()
  conn.close()


if __name__ == '__main__':
  params = connection.get_connection_params()
  try:
    connection.ensure_connection()
  except OperationalError as error:
    if 'database "' + params['database'] + '" does not exist' in error.message:
      print('Creating database "' + params['database'] + '"')
      create_database(params)
    else:
      raise error

  # skipping if already some tables exists
  if connection.introspection.table_names():
    sys.exit(0)

  print('Loading inital schema...')
  sql_file = open('schema.sql', 'U')

  try:
    output = []
    statements = re.compile(r";[ \t]*$", re.M)
    for statement in statements.split(sql_file.read().decode(settings.FILE_CHARSET)):
      # Remove any comments from the file
      statement = re.sub(ur"--.*([\n\Z]|$)", "", statement)
      if statement.strip():
        output.append(statement + u";")
    sql = u'\n'.join(output).encode('utf-8')
  finally:
    sql_file.close()

  cursor = connection.cursor()
  try:
    cursor.execute(sql)
    connection.commit()
  finally:
    cursor.close()
