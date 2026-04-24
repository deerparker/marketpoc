"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.vendorRequestsConfig = exports.vendorRequestsFields = void 0;
exports.vendorRequestsFields = [
    'id',
    'type',
    'data',
    'submitter_id',
    'reviewer_id',
    'reviewer_note',
    'status',
    'created_at',
    'updated_at'
];
exports.vendorRequestsConfig = {
    list: {
        defaults: exports.vendorRequestsFields,
        isList: true
    },
    retrieve: {
        defaults: exports.vendorRequestsFields,
        isList: false
    }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicXVlcnktY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL2FwaS92ZW5kb3IvcmVxdWVzdHMvcXVlcnktY29uZmlnLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFhLFFBQUEsb0JBQW9CLEdBQUc7SUFDbEMsSUFBSTtJQUNKLE1BQU07SUFDTixNQUFNO0lBQ04sY0FBYztJQUNkLGFBQWE7SUFDYixlQUFlO0lBQ2YsUUFBUTtJQUNSLFlBQVk7SUFDWixZQUFZO0NBQ2IsQ0FBQTtBQUVZLFFBQUEsb0JBQW9CLEdBQUc7SUFDbEMsSUFBSSxFQUFFO1FBQ0osUUFBUSxFQUFFLDRCQUFvQjtRQUM5QixNQUFNLEVBQUUsSUFBSTtLQUNiO0lBQ0QsUUFBUSxFQUFFO1FBQ1IsUUFBUSxFQUFFLDRCQUFvQjtRQUM5QixNQUFNLEVBQUUsS0FBSztLQUNkO0NBQ0YsQ0FBQSJ9