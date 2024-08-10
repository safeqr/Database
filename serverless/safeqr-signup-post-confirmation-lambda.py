import os
import pg8000

def lambda_handler(event, context):
    print(f"Event: {event}")
    
    # Extract user attributes from the Cognito event
    user_attributes = event['request']['userAttributes']
    
    # Extract specific attributes (modify as needed)
    user_id = user_attributes['sub']
    email = user_attributes['email']
    name = user_attributes.get('name', 'Default User')
    
    # Extract providerName from identities
    identities = user_attributes.get('identities', [])
    provider_name = identities[0]['providerName'] if identities else 'DefaultApp'
    print(f"providerName: {provider_name}")
    
    # Database connection parameters
    db_host = os.environ['RDS_HOST']
    db_name = os.environ['RDS_DB_NAME']
    db_user = os.environ['RDS_USER']
    db_password = os.environ['RDS_PASSWORD']
    db_port = 5432
    
    # Connect to the database
    try:
        conn = pg8000.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password
        )
        
        # Create a cursor
        cur = conn.cursor()
        print("Connection to db success!")
        
        # SQL query to insert user details
        insert_query = """
        INSERT INTO safeqr."user" (id, email, name, roles, source)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (id) DO UPDATE
        SET email = EXCLUDED.email, name = EXCLUDED.name, source = EXCLUDED.source;
        """
        
        # Execute the query
        cur.execute(insert_query, (user_id, email, name, ['appuser'], provider_name))
        
        # Commit the transaction
        conn.commit()
        
        print(f"User {user_id} inserted/updated successfully")
        
    except Exception as e:
        print(f"Database error: {str(e)}")
        raise e
    
    finally:
        # Close the cursor and connection
        if 'cur' in locals():
            cur.close()
        if 'conn' in locals():
            conn.close()
    
    # Return the event object back to Cognito
    return event