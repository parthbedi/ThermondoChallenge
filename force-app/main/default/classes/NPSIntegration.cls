//Description : Coordinates actions between order data, contact data, and the NPS API.
//It doesn't handle data retrieval or HTTP callouts directly but coordinates these actions.
public class NPSIntegration {
    private static final Set<String> sentEmails = new Set<String>();

    public class OrderIdWrapper {
        @InvocableVariable(label='Order IDs' description='Comma-separated Order IDs' required=true)
        public String orderIds;
    }

    @InvocableMethod(label='Send Order Data to NPS' description='Send Order Data to NPS API')
    public static void sendOrderData(List<OrderIdWrapper> orderIdsWrapperList) {
        OrderDataProvider orderDataProvider = new OrderDataProvider();

        for (OrderIdWrapper orderIdsWrapper : orderIdsWrapperList) {
            List<String> orderIdStrings = orderIdsWrapper.orderIds.split(',');
            Set<Id> orderIds = new Set<Id>();

            for (String orderIdString : orderIdStrings) {
                if (orderIdString != null && orderIdString.trim() != '') {
                    orderIds.add((Id)orderIdString.trim());
                }
            }

            Map<Id, Order> orderDetails = orderDataProvider.getOrderDetails(orderIds);

            for (Id orderId : orderIds) {
                if (orderDetails.containsKey(orderId)) {
                    Order order = orderDetails.get(orderId);
                    Contact billToContact = orderDataProvider.getBillToContact(order.BillToContactId);

                    try {
                        if (!sentEmails.contains(billToContact.Email)) {
                            NPSApiService.sendToNPS(order.OrderNumber, billToContact.Email);
                            sentEmails.add(billToContact.Email);
                        }
                    } catch (NPSIntegrationException ex) {
                        logError('Error occurred while sending order data to NPS API: ' + ex.getMessage());
                        throw ex;
                    }
                }
            }
        }
    }

    private static void logError(String errorMessage) {
        System.debug(errorMessage);
    }
}