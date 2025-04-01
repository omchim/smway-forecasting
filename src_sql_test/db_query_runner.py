import psycopg2
from typing import List, Tuple

class DatabaseQueryRunner:
    def __init__(self, dbname: str = "tech_test", user: str = "", host: str = "localhost"):
        """
        Initialize database connection parameters.
        
        Args:
            dbname (str): Name of the database to connect to
            user (str): Database user (defaults to system username)
            host (str): Database host
        """
        self.conn_params = {
            'dbname': dbname,
            'user': user,
            'host': host
        }

    def run_queries(self, queries: List[Tuple[str, str]]) -> None:
        """
        Run multiple SQL queries and print their results.
        
        Args:
            queries (List[Tuple[str, str]]): List of (query_description, sql_query) tuples
        """
        try:
            # Establish connection to the database
            with psycopg2.connect(**self.conn_params) as conn:
                with conn.cursor() as cur:
                    # Run each query
                    for description, query in queries:
                        print(f"\n{'='*50}")
                        print(f"Query: {description}")
                        print(f"SQL: {query}")
                        
                        cur.execute(query)
                        
                        try:
                            results = cur.fetchall()
                            
                            print("\nResults:")
                            if not results:
                                print("No results returned.")
                            else:
                                # Get column names
                                column_names = [desc[0] for desc in cur.description]
                                
                                # Print column headers
                                print(" | ".join(column_names))
                                print("-" * (sum(len(name) for name in column_names) + 3 * (len(column_names) - 1)))
                                
                                # Print data rows
                                for row in results:
                                    print(" | ".join(str(value) for value in row))
                        
                        except Exception as fetch_error:
                            print(f"Error fetching results: {fetch_error}")
        
        except psycopg2.Error as e:
            print(f"Database error: {e}")

def main():
    # Define queries as (description, SQL query) tuples
    queries = [
        (
            "The number of TV shows available in the tv_shows table", 
            "SELECT COUNT(*) AS total_tv_shows FROM tv_show;"
        ),
        (
            "The oldest TV show (name) available in the tv_shows table",
            """
            SELECT name, creation_year 
            FROM tv_show 
            ORDER BY creation_year ASC 
            LIMIT 1;
            """
        ),
        (
            "The TV show (name) with the highest number of episodes in the episode_sample table",
            """
            SELECT tv.name, COUNT(ep.id) AS episode_count
            FROM tv_show tv
            JOIN episode_sample ep ON tv.id = ep.show_id
            GROUP BY tv.name
            ORDER BY episode_count DESC
            LIMIT 1;
            """
        ),
        (
            "The TV show (name) with the longest episode title in the episode_sample table",
            """
            SELECT 
                tv.name, 
                ep.name AS episode_name, 
                LENGTH(TRIM(ep.name)) AS title_length
            FROM tv_show tv
            JOIN episode_sample ep ON tv.id = ep.show_id
            ORDER BY title_length DESC
            LIMIT 1;
            """
        ),
        (
            "The most recent episode by TV show",
            """
            SELECT 
                tv.name,
                ep.episode_name,
                ep.broadcast_date
            FROM (
                SELECT DISTINCT ON (show_id) 
                    show_id, 
                    name AS episode_name, 
                    broadcast_date
                FROM episode_sample
                ORDER BY show_id, broadcast_date DESC
            ) ep
            JOIN tv_show tv ON ep.show_id = tv.id;
            """
        )
    ]

    # Create and run the query runner
    runner = DatabaseQueryRunner()
    runner.run_queries(queries)

if __name__ == "__main__":
    main()