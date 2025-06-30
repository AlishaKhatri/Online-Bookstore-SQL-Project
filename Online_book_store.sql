-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
       Book_ID SERIAL PRIMARY KEY,
	   Title VARCHAR(100),
	   Author VARCHAR(100),
	   Genre VARCHAR(100),
	   Published_Year INT,
	   Price NUMERIC(10,2),
	   Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
     Customer_ID SERIAL PRIMARY KEY,
	 Name VARCHAR(100),
	 Email VARCHAR(100),
	 Phone VARCHAR(15),
	 City VARCHAR(50),
	 Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
      Order_ID SERIAL PRIMARY KEY,
	  Customer_ID INT REFERENCES Customers(Customer_ID),
	  Book_ID INT REFERENCES Books(Book_ID),
	  Order_Date DATE,
	  Quantity INT,
	  Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Retrieve all books in the "Fiction" genre:
SELECT * FROM Books WHERE genre='Fiction';

-- Find books publised after the year 1950:
SELECT * FROM Books WHERE published_year> 1950;

-- List all the customer from Canada
SELECT * FROM Customers WHERE Country ='Canada';

-- Show orders placed in NOVEMBER 2023
SELECT * FROM Orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock FROM Books;

-- Find the details of the most expensive book
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- Show all customers who ordered more than one quantity of a book
SELECT * FROM Orders WHERE Quantity>1;

-- Retrieve all orders where total amount exceeds $ 20
SELECT * FROM Orders WHERE Total_Amount>20;

-- List all the genres available in te Books table
SELECT DISTINCT Genre FROM Books;

-- Book with the lowest stock
SELECT * FROM Books ORDER BY Stock ASC LIMIT 1;

-- Total revenue from all orders 
SELECT SUM(Total_Amount) AS Revenue FROM Orders;

-- Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.Quantity) AS Total_books_sold
FROM Orders o
JOIN Books b  ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

-- Find the average price of books in the "Fantasy" genre;
SELECT AVG(Price) AS average_price
FROM Books
WHERE Genre = 'Fantasy';

-- List the customers who have placed at least 2 orders
SELECT Customer_ID, COUNT(Order_ID) AS Count_of_order
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID)>=2;

-- Most Frequently ordered Book
SELECT o.Book_ID, b.Title, COUNT(o.Order_ID) AS Count_of_order
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID	
GROUP BY o.Book_ID, b.Title
ORDER BY Count_of_order DESC LIMIT 1;

-- Top 3 most expensive books of 'Fantasy' Genre
SELECT Title, Book_ID, Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC LIMIT 3;

-- Total Quantity of books sold by each author
SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM Books b
JOIN Orders o ON o.Book_ID = b.Book_ID
GROUP BY b.Author;

-- Cities where customers spent over 30 on orders
SELECT DISTINCT c.City, o.Total_Amount
From Orders o
JOIN Customers c ON c.Customer_ID = o.Customer_ID
WHERE o.Total_Amount>30;

-- Customer who spend the most on orders
SELECT c.Name, c.Customer_ID, SUM(Total_Amount) AS total_spend
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name, c.Customer_ID
ORDER BY total_spend DESC LIMIT 1;


-- Stock remaining after fulfilling all orders
SELECT b.Book_ID, b.Title, b.Stock, COALESCE (SUM(o.Quantity),0) AS quantity_ordered,
      b.stock -  COALESCE (SUM(o.quantity)) AS Remaining_Quantity
FROM Books b
JOIN Orders o ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID;