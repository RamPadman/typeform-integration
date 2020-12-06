# Type form Integration with Salesforce via REST API
Typeform is a web-based platform used to create and store any kind of form (surveys, reviews, inscriptions to events, etc) and their responses.
As part of this requirement, I am making a call to the typeform platform via REST API to retrieve all the workspaces, forms and questions in salesforce through a batch scheduled to run daily.

I have designed the data model to store data accordingly. Although I have not included the object details here , you can design the data model at your convinience and modify the code accordingly. 

I am currently trying to match an existing account in system with the email mentioned in the forms, if not it will be linked to an "Unlinked Account". 

For the integration,
        The end points are configured in named credentials. 
        OAuth based authentication with a custom authentication provider class.
        
Schedulable apex to bring in the data daily. rest of the code is self explanatory and i have added the comments accordingly, 
There is also a LWC component which displays the list of questions and answers for every account.




