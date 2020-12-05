public class ResponseWrapper {
public Integer total_items;
    public List<items> items;
    public class items {
        public String landing_id;
        public String token;
        public String response_id;
        public List<answers> answers;
    }
    public class answers {
        public fieldObject field;
        public String type;
        public Boolean x_boolean;
        public String text;
        public Integer x_number;
        public String email;
    }
    public class fieldObject {
        public String id;
        public String type;
    }
}