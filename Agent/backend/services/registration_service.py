from database.db import get_connection

def register_user(name, mobilenumber, dateofbirth,sportregistered):

    conn = get_connection()
    cursor = conn.cursor()

    query = """
    INSERT INTO userdetails
    (name, mobilenumber, dateofbirth, sportregistered)
    VALUES (%s, %s, %s, %s)
    """

    cursor.execute(
        query,
        (name, mobilenumber, dateofbirth, sportregistered)
    )

    conn.commit()

    cursor.close()
    conn.close()


def get_user_by_mobile(mobile):

    conn = get_connection()
    cursor = conn.cursor()

    query = """
    SELECT *
    FROM userdetails
    WHERE mobilenumber = %s
    """

    cursor.execute(query, (mobile,))

    user = cursor.fetchone()

    cursor.close()
    conn.close()

    return user

def get_all_users():

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT *
        FROM userdetails
    """)

    users = cursor.fetchall()

    cursor.close()
    conn.close()

    return users