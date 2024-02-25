package com.example.service;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

// Servlet annotation to map the servlet to a specific URL
@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {

    // Database connection details
    String url = "jdbc:sqlserver://my-sqldb-server.database.windows.net:1433;encrypt=false;trustServerCertificate=false;loginTimeout=30;database=mysqldb;";
    String user = "sql_admin@my-sqldb-server";
    String password = "#6316980@DB";

    // Variables for salary and various calculations
    double Salary = 0;
    double Tax = 0;
    double EPF = 0;
    double ETF = 0;
    double net_salary = 0;

    // Initialization method, registering JDBC driver
    public void init() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    // Handling POST requests
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Extracting salary from the request parameter
        Salary = Math.round(Double.parseDouble(request.getParameter("salary")) * 100.0) / 100.0;

        // Calculating tax, EPF, ETF, and net salary using a taxCalculatorImplent class
        Tax = Math.round(new taxCalculatorImplent().taxCalculation(Salary) * 100.0) / 100.0;
        EPF = Math.round(new taxCalculatorImplent().epfCalculation(Salary) * 100.0) / 100.0;
        ETF = Math.round(new taxCalculatorImplent().etfCalculation(Salary) * 100.0) / 100.0;
        net_salary = Math.round((Salary - (Tax + EPF + ETF)) * 100.0) / 100.0;

        // Creating a result object with calculated values
        TaxCalculationResult result = new TaxCalculationResult(Salary, Tax, EPF, ETF, net_salary);

        // Convert data object to JSON
        String jsonData = new Gson().toJson(result);

        // Write JSON data to the response
        response.getWriter().write(jsonData);

        // SQL query to insert the calculated values into the database
        String query = "INSERT INTO taxcalculations(salary, tax, epf, etf, net_salary) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(url, user, password);
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            // Setting parameters for the prepared statement
            preparedStatement.setDouble(1, Salary);
            preparedStatement.setDouble(2, Tax);
            preparedStatement.setDouble(3, EPF);
            preparedStatement.setDouble(4, ETF);
            preparedStatement.setDouble(5, net_salary);

            // Executing the update query
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace(); // Handle exceptions properly in a production environment
            response.getWriter().println("Error saving salary to the database.");
        }
    }

    // Handling GET requests
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");

        // List to store retrieved tax calculation entries
        List<TaxCalculationResult> taxCalcEntries = new ArrayList<>();

        // SQL query to retrieve entries from the database
        String query = "SELECT salary, tax, epf, etf, net_salary FROM taxcalculations";

        try (Connection connection = DriverManager.getConnection(url, user, password);
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            // Executing the query and getting the result set
            ResultSet resultSet = preparedStatement.executeQuery();

            // Processing each row in the result set
            while (resultSet.next()) {
                Salary = resultSet.getDouble("salary");
                Tax = resultSet.getDouble("tax");
                EPF = resultSet.getDouble("epf");
                ETF = resultSet.getDouble("etf");
                net_salary = resultSet.getDouble("net_salary");

                // Creating TaxCalculationResult objects and adding to the list
                TaxCalculationResult taxCalcEntry = new TaxCalculationResult(Salary, Tax, EPF, ETF, net_salary);
                taxCalcEntries.add(taxCalcEntry);
            }

            // Setting the list as an attribute for the request
            request.setAttribute("taxCalcEntries", taxCalcEntries);

            // Forwarding the request to the history.jsp page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/history.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace(); // Handle exceptions properly in a production environment
            response.getWriter().println("Error retrieving salary from the database.");
        }
    }

    public void destroy() {
    }
}
