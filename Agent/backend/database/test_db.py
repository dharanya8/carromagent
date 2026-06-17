import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port="5433",
        database="whatsappagent",
        user="postgres",
        password="1234"
    )

    print("✅ Database Connected Successfully")

    cur = conn.cursor()
    cur.execute("SELECT current_database();")
    print(cur.fetchone())

    conn.close()

except Exception as e:
    print("❌ Error:", e)