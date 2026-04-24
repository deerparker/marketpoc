"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.adminReviewsConfig = exports.adminReviewsFields = void 0;
exports.adminReviewsFields = [
    'id',
    'reference',
    'rating',
    'customer_note',
    'seller_note',
    'created_at',
    'updated_at'
];
exports.adminReviewsConfig = {
    list: {
        defaults: exports.adminReviewsFields,
        isList: true
    },
    retrieve: {
        defaults: exports.adminReviewsFields,
        isList: false
    }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicXVlcnktY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL2FwaS9hZG1pbi9yZXZpZXdzL3F1ZXJ5LWNvbmZpZy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBYSxRQUFBLGtCQUFrQixHQUFHO0lBQ2hDLElBQUk7SUFDSixXQUFXO0lBQ1gsUUFBUTtJQUNSLGVBQWU7SUFDZixhQUFhO0lBQ2IsWUFBWTtJQUNaLFlBQVk7Q0FDYixDQUFBO0FBRVksUUFBQSxrQkFBa0IsR0FBRztJQUNoQyxJQUFJLEVBQUU7UUFDSixRQUFRLEVBQUUsMEJBQWtCO1FBQzVCLE1BQU0sRUFBRSxJQUFJO0tBQ2I7SUFDRCxRQUFRLEVBQUU7UUFDUixRQUFRLEVBQUUsMEJBQWtCO1FBQzVCLE1BQU0sRUFBRSxLQUFLO0tBQ2Q7Q0FDRixDQUFBIn0=