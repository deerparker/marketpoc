"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateRequestDataWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const steps_1 = require("../steps");
exports.updateRequestDataWorkflow = (0, workflows_sdk_1.createWorkflow)('update-request-data', function (input) {
    return new workflows_sdk_1.WorkflowResponse((0, steps_1.updateRequestDataStep)(input));
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidXBkYXRlLXJlcXVlc3QtZGF0YS5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3NyYy93b3JrZmxvd3MvcmVxdWVzdHMvd29ya2Zsb3dzL3VwZGF0ZS1yZXF1ZXN0LWRhdGEudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEsMkRBQTBFO0FBSTFFLG9DQUFnRDtBQUVuQyxRQUFBLHlCQUF5QixHQUFHLElBQUEsOEJBQWMsRUFDckQscUJBQXFCLEVBQ3JCLFVBQVUsS0FBMkI7SUFDbkMsT0FBTyxJQUFJLGdDQUFnQixDQUFDLElBQUEsNkJBQXFCLEVBQUMsS0FBSyxDQUFDLENBQUMsQ0FBQTtBQUMzRCxDQUFDLENBQ0YsQ0FBQSJ9