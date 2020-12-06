public class MockHTTPRespGenerator implements HttpCalloutMock {
	public HTTPResponse respond(HTTPRequest req) 
        { 
            String strBody;
            System.debug('reeeee'+req.getEndpoint());
            //provide different bodybased on endpoint
            if(req.getEndpoint() == 'callout:TypeForm/workspaces') {
                strBody = '{"items":[{"default":false,"forms":{"count":1,"href":"https://api.typeform.com/forms?workspace_id=PSwGuZ"},"id":"PSwGuZ","name":"Marketing"}]}';
            }
            if(req.getEndpoint() == 'callout:TypeForm/forms?workspace_id=PSwGuZ') {
                strBody = '{"total_items":1,"page_count":1,"items":[{"id":"R5B3rv","title":"Grand opening invitation","last_updated_at":"2019-09-09T20:50:30Z","settings":{"is_public":false,"is_trial":true}}]}';
            }
            if(req.getEndpoint() == 'callout:TypeForm/forms/R5B3rv') {
                strBody = '{"id": "R5B3rv","title": "Grand opening invitation","fields": [ {'
							+'"id": "pwpVmQZ0BZTu",'
                            +'"title": "Were so excited to launch our third outlet in town. And of course, we want to celebrate with you!",'
                            +'"ref": "31b79e4d38c8faaa",'
                            +'"properties": {'
                            +'"hide_marks": false,'
                            +'"button_text": "So exciting!"'
                            +'},'
                            +'"type": "statement"'
                            +'},'
                              +'{'
                            +'"id": "bbPkB9wU6ISi",'
                            +'"title": "So, can you make it?",'
                            +'"ref": "c98dc42e476ea5b0",'
                            +'"validations": {'
                            +'"required": false'
                            +'},'
                            +'"type": "yes_no"'
                    +'}]}';
                            
            } if(req.getEndpoint() == 'callout:TypeForm/forms/R5B3rv/responses') {
                	
                strBody = '{"total_items": 35,'
                    +'"page_count": 2,'
                    +'"items": ['
                     +' {'
                   +' "landing_id": "j1mq7fsf64bf5gc1yqj1mq7fsxgwoyqp",'
                    +'"token": "j1mq7fsf64bf5gc1yqj1mq7fsxgwoyqp",'
                    +'"response_id": "j1mq7fsf64bf5gc1yqj1mq7fsxgwoyqp",'
                    +'"landed_at": "2020-04-04T01:00:53Z",'
                    +'"submitted_at": "2020-04-04T01:01:09Z",'
                    +'"metadata": {'
                    +'"user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36",'
                    +'"platform": "other",'
                    +'"referer": "https://group.typeform.com/to/Q7dTxN",'
                    +'"network_id": "219e3c07c5",'
                    +'"browser": "default"'
                   +' },'
                    +'"hidden": {},'
                    +'"calculated": {'
                    +'"score": 0'
                    +'},'
                    +'"answers": ['
                    +'  {'
                    +'"field": {'
                    +'"id": "JGrpx4odt20t",'
                    +'"ref": "af327bc4-92f2-44b0-880d-61d7f90fb12e",'
                    +'"type": "short_text"'
                    +'},'
                    +'"type": "text",'
                    +'"text": "eric"'
                    +'},'
                     +' {'
                    +'"field": {'
                    +'"id": "C73LSWWt41ci",'
                    +'"ref": "9e97aaa8-340e-40fd-8bab-57331f3e9136",'
                    +'"type": "opinion_scale"'
                    +'},'
                    +'"type": "number",'
                    +'"number": 4'
                    +'},'
                     +' {'
                    +'"field": {'
                    +'"id": "rBCqgDmCQta1",'
                    +'"ref": "2278301f-681e-4d48-afc3-103ab4032146",'
                    +'"type": "yes_no"'
                    +'},'
                    +'"type": "boolean",'
                   +' "boolean": true'
                    +'},'
                    +'  {'
                   +' "field": {'
                    +'"id": "LcABr6Ca3Xc7",'
                    +'"ref": "2b935caf-13c3-4b0c-9389-bdced863059f",'
                    +'"type": "email"'
                   +' },'
                    +'"type": "email",'
                    +'"email": "eric0404@gmail.com"}] }]}';
            }
            
            // Create a fake response 
            HttpResponse res = new HttpResponse(); 
            res.setHeader('Content-Type', 'application/xml'); 
            res.setBody(strBody); 
            res.setStatusCode(200); 
            return res; 
        } 
}