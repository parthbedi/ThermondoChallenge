//Description : This class deals specifically with fetching order details and contact information from Salesforce.
public class OrderDataProvider {
    public Map<Id, Order> getOrderDetails(Set<Id> orderIds) {
        return new Map<Id, Order>([SELECT Id, OrderNumber, Status, BillToContactId FROM Order WHERE Id IN :orderIds]);
    }

    public Contact getBillToContact(Id contactId) {
        return [SELECT Id, Email FROM Contact WHERE Id = :contactId LIMIT 1];
    }
}