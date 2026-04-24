"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.vendorReturnOrderRequestQueryConfig = exports.vendorReturnOrderRequestFields = void 0;
exports.vendorReturnOrderRequestFields = [
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
    'order.*'
];
exports.vendorReturnOrderRequestQueryConfig = {
    list: {
        defaults: exports.vendorReturnOrderRequestFields,
        isList: true
    },
    retrieve: {
        defaults: exports.vendorReturnOrderRequestFields,
        isList: false
    }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicXVlcnktY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL2FwaS92ZW5kb3IvcmV0dXJuLXJlcXVlc3QvcXVlcnktY29uZmlnLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFhLFFBQUEsOEJBQThCLEdBQUc7SUFDNUMsSUFBSTtJQUNKLGFBQWE7SUFDYixlQUFlO0lBQ2Ysb0JBQW9CO0lBQ3BCLHNCQUFzQjtJQUN0QixzQkFBc0I7SUFDdEIsbUJBQW1CO0lBQ25CLHFCQUFxQjtJQUNyQixxQkFBcUI7SUFDckIsUUFBUTtJQUNSLGNBQWM7SUFDZCxTQUFTO0NBQ1YsQ0FBQTtBQUVZLFFBQUEsbUNBQW1DLEdBQUc7SUFDakQsSUFBSSxFQUFFO1FBQ0osUUFBUSxFQUFFLHNDQUE4QjtRQUN4QyxNQUFNLEVBQUUsSUFBSTtLQUNiO0lBQ0QsUUFBUSxFQUFFO1FBQ1IsUUFBUSxFQUFFLHNDQUE4QjtRQUN4QyxNQUFNLEVBQUUsS0FBSztLQUNkO0NBQ0YsQ0FBQSJ9