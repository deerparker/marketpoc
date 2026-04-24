"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.storeReturnOrderRequestQueryConfig = exports.storeReturnOrderRequestFields = void 0;
exports.storeReturnOrderRequestFields = [
    'id',
    'customer_id',
    'customer_note',
    'vendor_reviewer_id',
    'vendor_reviewer_note',
    'vendor_reviewer_date',
    'admin_reviewer_id',
    'admin_reviewer_note',
    'admin_reviewer_date',
    'status',
    'line_items.*',
    'order.*',
    'order.items.*',
    'order.seller.*'
];
exports.storeReturnOrderRequestQueryConfig = {
    list: {
        defaults: [],
        isList: true
    },
    retrieve: {
        defaults: [],
        isList: false
    }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicXVlcnktY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL2FwaS9zdG9yZS9yZXR1cm4tcmVxdWVzdC9xdWVyeS1jb25maWcudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQWEsUUFBQSw2QkFBNkIsR0FBRztJQUMzQyxJQUFJO0lBQ0osYUFBYTtJQUNiLGVBQWU7SUFDZixvQkFBb0I7SUFDcEIsc0JBQXNCO0lBQ3RCLHNCQUFzQjtJQUN0QixtQkFBbUI7SUFDbkIscUJBQXFCO0lBQ3JCLHFCQUFxQjtJQUNyQixRQUFRO0lBQ1IsY0FBYztJQUNkLFNBQVM7SUFDVCxlQUFlO0lBQ2YsZ0JBQWdCO0NBQ2pCLENBQUE7QUFFWSxRQUFBLGtDQUFrQyxHQUFHO0lBQ2hELElBQUksRUFBRTtRQUNKLFFBQVEsRUFBRSxFQUFFO1FBQ1osTUFBTSxFQUFFLElBQUk7S0FDYjtJQUNELFFBQVEsRUFBRTtRQUNSLFFBQVEsRUFBRSxFQUFFO1FBQ1osTUFBTSxFQUFFLEtBQUs7S0FDZDtDQUNGLENBQUEifQ==