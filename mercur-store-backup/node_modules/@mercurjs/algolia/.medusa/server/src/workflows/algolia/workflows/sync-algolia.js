"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncAlgoliaWorkflow = void 0;
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const steps_1 = require("../steps");
exports.syncAlgoliaWorkflow = (0, workflows_sdk_1.createWorkflow)('sync-algolia-workflow', function () {
    return new workflows_sdk_1.WorkflowResponse((0, steps_1.syncAlgoliaProductsStep)());
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic3luYy1hbGdvbGlhLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9hbGdvbGlhL3dvcmtmbG93cy9zeW5jLWFsZ29saWEudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEsMkRBQTBFO0FBRTFFLG9DQUFrRDtBQUVyQyxRQUFBLG1CQUFtQixHQUFHLElBQUEsOEJBQWMsRUFDL0MsdUJBQXVCLEVBQ3ZCO0lBQ0UsT0FBTyxJQUFJLGdDQUFnQixDQUFDLElBQUEsK0JBQXVCLEdBQUUsQ0FBQyxDQUFBO0FBQ3hELENBQUMsQ0FDRixDQUFBIn0=