"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.upsertDefaultCommissionRuleWorkflow = void 0;
const core_flows_1 = require("@medusajs/medusa/core-flows");
const workflows_sdk_1 = require("@medusajs/workflows-sdk");
const steps_1 = require("../steps");
exports.upsertDefaultCommissionRuleWorkflow = (0, workflows_sdk_1.createWorkflow)('upsert-default-commission-rule', function (input) {
    const existingRule = (0, core_flows_1.useQueryGraphStep)({
        entity: 'commission_rule',
        fields: ['id'],
        filters: {
            reference: 'site'
        }
    });
    (0, workflows_sdk_1.when)(existingRule, (existingRule) => !!existingRule.data.length).then(() => {
        const id = (0, workflows_sdk_1.transform)(existingRule, (existingRule) => existingRule.data[0]).id;
        (0, steps_1.deleteCommissionRuleStep)(id);
    });
    return new workflows_sdk_1.WorkflowResponse((0, steps_1.createCommissionRuleStep)(input));
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidXBzZXJ0LWRlZmF1bHQtY29tbWlzc2lvbi1ydWxlLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vLi4vLi4vLi4vLi4vLi4vc3JjL3dvcmtmbG93cy9jb21taXNzaW9uL3dvcmtmbG93cy91cHNlcnQtZGVmYXVsdC1jb21taXNzaW9uLXJ1bGUudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7O0FBQUEsNERBQStEO0FBQy9ELDJEQUtnQztBQUloQyxvQ0FBNkU7QUFFaEUsUUFBQSxtQ0FBbUMsR0FBRyxJQUFBLDhCQUFjLEVBQy9ELGdDQUFnQyxFQUNoQyxVQUFVLEtBQThCO0lBQ3RDLE1BQU0sWUFBWSxHQUFHLElBQUEsOEJBQWlCLEVBQUM7UUFDckMsTUFBTSxFQUFFLGlCQUFpQjtRQUN6QixNQUFNLEVBQUUsQ0FBQyxJQUFJLENBQUM7UUFDZCxPQUFPLEVBQUU7WUFDUCxTQUFTLEVBQUUsTUFBTTtTQUNsQjtLQUNGLENBQUMsQ0FBQTtJQUVGLElBQUEsb0JBQUksRUFBQyxZQUFZLEVBQUUsQ0FBQyxZQUFZLEVBQUUsRUFBRSxDQUFDLENBQUMsQ0FBQyxZQUFZLENBQUMsSUFBSSxDQUFDLE1BQU0sQ0FBQyxDQUFDLElBQUksQ0FDbkUsR0FBRyxFQUFFO1FBQ0gsTUFBTSxFQUFFLEdBQUcsSUFBQSx5QkFBUyxFQUNsQixZQUFZLEVBQ1osQ0FBQyxZQUFZLEVBQUUsRUFBRSxDQUFDLFlBQVksQ0FBQyxJQUFJLENBQUMsQ0FBQyxDQUFDLENBQ3ZDLENBQUMsRUFBRSxDQUFBO1FBQ0osSUFBQSxnQ0FBd0IsRUFBQyxFQUFFLENBQUMsQ0FBQTtJQUM5QixDQUFDLENBQ0YsQ0FBQTtJQUVELE9BQU8sSUFBSSxnQ0FBZ0IsQ0FBQyxJQUFBLGdDQUF3QixFQUFDLEtBQUssQ0FBQyxDQUFDLENBQUE7QUFDOUQsQ0FBQyxDQUNGLENBQUEifQ==