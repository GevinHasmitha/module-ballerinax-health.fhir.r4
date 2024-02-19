import ballerina/io;
import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.validator;


service http:Service / on new http:Listener(9090) {

     @http:ResourceConfig {
        cors: {
            allowOrigins: ["http://localhost:3000 "],
            allowCredentials: true
        }
     }

   resource function post sampleResource (@http:Payload json message) returns string[]?{
       var validationResult =  validator:validate(message);
       
            

    if validationResult is error {      

            var validationMessage = validationResult.message().toString();

            //Gets the detailed errors from the validation error
            r4:FHIRIssueDetail[] issueDetails =  validationResult.detail().issues;
            validator:FHIRValidationIssueDetail issue = <validator:FHIRValidationIssueDetail> issueDetails[0];
            string[]? errorsArray = issue.detailedErrors;

            if (validationMessage is string){
                io:println("=============================================");
                io:println(validationMessage);
                io:println(issue.diagnostic);
                io:println(errorsArray);
                return errorsArray;
            } 
        } 
        io:println(validationResult.toString());
        io:println("Validation successful");
        return ();

    }
}