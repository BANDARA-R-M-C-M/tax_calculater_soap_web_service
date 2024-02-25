<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>home</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
</head>

<body class="p-3 m-0 border-0 bd-example m-0 border-0">

<nav class="navbar navbar-expand-lg "style="background-color: #35A29F; "data-bs-theme="dark">
    <div class="container-fluid">
        <a class="navbar-brand"><b>TAX</b> Calculator</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0" style="display: flex;justify-content: space-between;">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="hello-servlet?action=view">History</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div><p></p></div>
<div class="row align-items-md-stretch">
    <div class="col-md-6">
        <div class="h-100 p-5  rounded-3 custom-border-radius-green"style="background-color: #35A29F; color:snow">
            <h2>Your Salary:</h2>
            <form id="salaryForm" method="post" action="hello-servlet">
                <input id="salaryInput" class="form-control" type="text" placeholder="Salary input here..." aria-label="readonly input example" name="salary"><br>
                <small id="salaryError" style="color: white"></small><br><br>
                <input class="btn btn-outline-light" type="submit" value="Submit">
            </form>

        </div>
    </div>

    <div class="col-md-6">
        <div class="h-100 p-5 border rounded-3 custom-border-radius-gray" style="background-color: #FFF6BF">
            <h2>Salary Details</h2>
            <!-- Custom-styled input fields with labels -->
            <div class="mb-3 custom-input">
                <label for="grossSalary" class="form-label">Gross Salary</label>
                <div class="input-group">
                    <span class="input-group-text custom-input-addon" style="background-color: #efd258">Rs.</span>
                    <input id="grossSalary" type="text" class="form-control custom-input-field" aria-label="Gross Salary" readonly>
                </div>
            </div>
            <div class="mb-3 custom-input">
                <label for="tax" class="form-label">Tax Deduction</label>
                <div class="input-group">
                    <span class="input-group-text custom-input-addon" style="background-color: #efd258">Rs.</span>
                    <input id="tax" type="text" class="form-control custom-input-field" aria-label="Tax Deduction" readonly>
                </div>
            </div>
            <div class="mb-3 custom-input">
                <label for="epf" class="form-label">EPF Contribution</label>
                <div class="input-group">
                    <span class="input-group-text custom-input-addon" style="background-color: #efd258">Rs.</span>
                    <input id="epf" type="text" class="form-control custom-input-field" aria-label="EPF Contribution" readonly>
                </div>
            </div>
            <div class="mb-3 custom-input">
                <label for="etf" class="form-label">ETF Contribution</label>
                <div class="input-group">
                    <span class="input-group-text custom-input-addon" style="background-color: #efd258">Rs.</span>
                    <input id="etf" type="text" class="form-control custom-input-field" aria-label="ETF Contribution" readonly>
                </div>
            </div>
            <div class="mb-3 custom-input">
                <label for="net_salary" class="form-label">Net Salary</label>
                <div class="input-group">
                    <span class="input-group-text custom-input-addon" style="background-color: #efd258">Rs.</span>
                    <input id="net_salary" type="text" class="form-control custom-input-field" aria-label="Net Salary" readonly>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

<!-- Script to handle form submission using AJAX -->
<script>
    $(document).ready(function () {
        // Attach a submit event listener to the salaryForm
        $("#salaryForm").submit(function (event) {
            event.preventDefault(); // Prevent the default form submission
            submitForm(); // Call the custom submitForm function
        });
    });

    // Custom function to handle form submission via AJAX
    function submitForm() {
        // Get the salary value from the input field
        var salary = $("input[name='salary']").val();

        // Perform an AJAX request to the hello-servlet endpoint with the provided salary data
        $.ajax({
            type: "POST",
            url: "hello-servlet",
            data: { salary: salary },
            dataType: "json",
            success: function (data) {
                // Update the relevant parts of your HTML with the received data
                $("#grossSalary").val(data.grossSalary);
                $("#tax").val(data.tax);
                $("#epf").val(data.epf);
                $("#etf").val(data.etf);
                $("#net_salary").val(data.net_salary);
            },
            error: function () {
                alert("Error submitting the form"); // Display an alert on AJAX error
            }
        });
    }
</script>

<!-- Script to validate input for salaryInput -->
<script>
    // Add an event listener for keypress on the salaryInput element
    document.getElementById("salaryInput").addEventListener("keypress", function (event) {
        // Check if the key pressed is a number or a dot (for decimal numbers)
        if (!/[\d.]/.test(String.fromCharCode(event.keyCode))) {
            event.preventDefault();
            document.getElementById("salaryError").innerText = "Only positive numbers are allowed.";
        } else {
            document.getElementById("salaryError").innerText = ""; // Clear any previous error message
        }
    });
</script>

