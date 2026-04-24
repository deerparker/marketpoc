"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.adminCommissionLinesQueryConfig = exports.adminCommissionRuleQueryConfig = exports.adminCommissionRuleFields = void 0;
exports.adminCommissionRuleFields = [
    'id',
    'name',
    'reference',
    'reference_id',
    'is_active',
    'rate_id',
    'created_at',
    'updated_at',
    '*rate'
];
exports.adminCommissionRuleQueryConfig = {
    list: {
        defaults: exports.adminCommissionRuleFields,
        isList: true
    },
    retrieve: {
        defaults: exports.adminCommissionRuleFields,
        isList: false
    }
};
exports.adminCommissionLinesQueryConfig = {
    list: {
        defaults: [],
        isList: true
    },
    retrieve: {
        defaults: [],
        isList: false
    }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicXVlcnktY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL2FwaS9hZG1pbi9jb21taXNzaW9uL3F1ZXJ5LWNvbmZpZy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7QUFBYSxRQUFBLHlCQUF5QixHQUFHO0lBQ3ZDLElBQUk7SUFDSixNQUFNO0lBQ04sV0FBVztJQUNYLGNBQWM7SUFDZCxXQUFXO0lBQ1gsU0FBUztJQUNULFlBQVk7SUFDWixZQUFZO0lBQ1osT0FBTztDQUNSLENBQUE7QUFFWSxRQUFBLDhCQUE4QixHQUFHO0lBQzVDLElBQUksRUFBRTtRQUNKLFFBQVEsRUFBRSxpQ0FBeUI7UUFDbkMsTUFBTSxFQUFFLElBQUk7S0FDYjtJQUNELFFBQVEsRUFBRTtRQUNSLFFBQVEsRUFBRSxpQ0FBeUI7UUFDbkMsTUFBTSxFQUFFLEtBQUs7S0FDZDtDQUNGLENBQUE7QUFFWSxRQUFBLCtCQUErQixHQUFHO0lBQzdDLElBQUksRUFBRTtRQUNKLFFBQVEsRUFBRSxFQUFFO1FBQ1osTUFBTSxFQUFFLElBQUk7S0FDYjtJQUNELFFBQVEsRUFBRTtRQUNSLFFBQVEsRUFBRSxFQUFFO1FBQ1osTUFBTSxFQUFFLEtBQUs7S0FDZDtDQUNGLENBQUEifQ==