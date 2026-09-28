CREATE TABLE bank_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    balance NUMERIC(10,2)
);

CREATE TABLE customer_audit (
    audit_id SERIAL PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(50),
    action VARCHAR(20),
    action_time TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_customer_action()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO customer_audit (customer_id, customer_name, action, action_time)
        VALUES (NEW.customer_id, NEW.customer_name, 'ADDED', CURRENT_TIMESTAMP);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO customer_audit (customer_id, customer_name, action, action_time)
        VALUES (OLD.customer_id, OLD.customer_name, 'REMOVED', CURRENT_TIMESTAMP);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_customer_audit
AFTER INSERT OR DELETE ON bank_customer
FOR EACH ROW
EXECUTE FUNCTION log_customer_action();

INSERT INTO bank_customer VALUES (3, 'Aman', 90000);
INSERT INTO bank_customer VALUES (1, 'Rahul', 50000);

DELETE FROM bank_customer WHERE customer_id = 1;

SELECT 
    audit_id, 
    customer_id, 
    customer_name, 
    action, 
    action_time 
FROM customer_audit;