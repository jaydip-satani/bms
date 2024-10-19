# Bank Management System

## Description

The **Bank Management System** is a web application that enables administrators and employees to manage bank accounts, loan applications, and transactions effectively. It provides a secure and user-friendly interface for creating, updating, and closing accounts while ensuring authorized access to sensitive functionalities.

## Features

- **User Authentication:** Role-based access control for administrators and employees.
- **Account Management:** View, create, update, and close customer accounts.
- **Loan Management:** Review, approve, or reject loan applications.
- **Transaction Processing:** Process deposits and withdrawals securely.
- **Reporting:** Generate reports for accounts and transactions.

## Prerequisites

Before running the application, ensure you have the following installed:

- **Java Development Kit (JDK)** 8 or higher
- **Apache Tomcat Server** (or any compatible servlet container)
- **MySQL Database**
- **JDBC Driver for MySQL** (`mysql-connector-java-x.x.x.jar`)
- **Integrated Development Environment (IDE)** (e.g., Eclipse, IntelliJ IDEA, or Visual Studio Code)

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://jaydip-satani/bms
   cd your-project-directory
   ```

2. **Set Up MySQL Database:**
   - Create a new database named `bankingdb`.
   - Execute the SQL scripts provided in the project (if any) to create the necessary tables (e.g., accounts, loans, users).
   - Adjust any hardcoded database credentials in the JSP files as needed.

3. **Add JDBC Driver:**
   - Place the `mysql-connector-java-x.x.x.jar` file in the `lib` directory of your Apache Tomcat server.

4. **Deploy the Application:**
   - Copy the project files into the `webapps` directory of your Apache Tomcat server.
   - Ensure that your directory structure follows the standard layout for web applications (`WEB-INF`, `META-INF`, etc.).

## Running the Application

1. **Start Apache Tomcat:**
   Navigate to the Apache Tomcat installation directory and run:
   ```bash
   ./bin/startup.sh   # For Linux/Mac
   .\bin\startup.bat  # For Windows
   ```

2. **Access the Application:**
   Open your web browser and go to:
   ```bash
   http://localhost:8080/bms
   ```

3. **Login:**
   Use the admin or employee credentials to log in and access the features of the application.

## Usage

- **As an Admin:** You can manage accounts, loan applications, and generate reports.
- **As an Employee:** You can process transactions and handle customer requests.

## Contact

For any inquiries or contributions, feel free to reach out to the project maintainer at [jaydipbsatani@gmail.com].
