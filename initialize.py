import re
import sys

from django.conf import settings
from django.db import connection

if __name__ == '__main__':
  # skipping if already some tables exists
  if connection.introspection.table_names():
    sys.exit(0)

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
