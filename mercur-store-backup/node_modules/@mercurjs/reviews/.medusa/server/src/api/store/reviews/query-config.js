"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.storeReviewQueryConfig = exports.storeReviewFields = void 0;
exports.storeReviewFields = [
    'id',
    'reference',
    'rating',
    'customer_note',
    'customer.*',
    'seller_note',
    'created_at',
    'updated_at'
];
exports.storeReviewQueryConfig = {
    list: {
        defaults: exports.storeReviewFields,
        isList: true
    },
    retrieve: {
        defaults: exports.storeReviewFields,
        isList: false
    }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicXVlcnktY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL2FwaS9zdG9yZS9yZXZpZXdzL3F1ZXJ5LWNvbmZpZy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBYSxRQUFBLGlCQUFpQixHQUFHO0lBQy9CLElBQUk7SUFDSixXQUFXO0lBQ1gsUUFBUTtJQUNSLGVBQWU7SUFDZixZQUFZO0lBQ1osYUFBYTtJQUNiLFlBQVk7SUFDWixZQUFZO0NBQ2IsQ0FBQTtBQUVZLFFBQUEsc0JBQXNCLEdBQUc7SUFDcEMsSUFBSSxFQUFFO1FBQ0osUUFBUSxFQUFFLHlCQUFpQjtRQUMzQixNQUFNLEVBQUUsSUFBSTtLQUNiO0lBQ0QsUUFBUSxFQUFFO1FBQ1IsUUFBUSxFQUFFLHlCQUFpQjtRQUMzQixNQUFNLEVBQUUsS0FBSztLQUNkO0NBQ0YsQ0FBQSJ9