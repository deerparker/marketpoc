"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.adminRequestsConfig = exports.adminRequestsFields = void 0;
exports.adminRequestsFields = [
    'id',
    'type',
    'data',
    'submitter_id',
    'reviewer_id',
    'reviewer_note',
    'status',
    'seller.*',
    'created_at',
    'updated_at'
];
exports.adminRequestsConfig = {
    list: {
        defaults: exports.adminRequestsFields,
        isList: true
    },
    retrieve: {
        defaults: exports.adminRequestsFields,
        isList: false
    }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicXVlcnktY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL2FwaS9hZG1pbi9yZXF1ZXN0cy9xdWVyeS1jb25maWcudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQWEsUUFBQSxtQkFBbUIsR0FBRztJQUNqQyxJQUFJO0lBQ0osTUFBTTtJQUNOLE1BQU07SUFDTixjQUFjO0lBQ2QsYUFBYTtJQUNiLGVBQWU7SUFDZixRQUFRO0lBQ1IsVUFBVTtJQUNWLFlBQVk7SUFDWixZQUFZO0NBQ2IsQ0FBQTtBQUVZLFFBQUEsbUJBQW1CLEdBQUc7SUFDakMsSUFBSSxFQUFFO1FBQ0osUUFBUSxFQUFFLDJCQUFtQjtRQUM3QixNQUFNLEVBQUUsSUFBSTtLQUNiO0lBQ0QsUUFBUSxFQUFFO1FBQ1IsUUFBUSxFQUFFLDJCQUFtQjtRQUM3QixNQUFNLEVBQUUsS0FBSztLQUNkO0NBQ0YsQ0FBQSJ9