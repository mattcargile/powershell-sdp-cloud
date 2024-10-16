
. "$PSScriptRoot\Format-ZohoCriteria.ps1"
. "$PSScriptRoot\Resolve-UserField"

function Format-ZohoSearch {
    param (
        $Status,

        [string]
        $Technician,

        [string]
        $TechnicianLogicalOperator,

        [Alias('CreatedBy')]
        [string]
        $Creator,

        [string]
        $Requester,

        [string]
        $Category,

        [string]
        $SubCategory,

        [string]
        $Item,

        [string]
        $Group,

        # And/Or Logical Operator
        [string]
        $GroupLogicalOperator,

        [string]
        $Department,

        [string]
        $Level,

        [string]
        $Priority,

        [string]
        $Urgency,

        [string]
        $Impact
    )

    $Criteria = @()

    $Shared = @{
        Condition = 'is'
    }

    if ($PSBoundParameters.ContainsKey('Status')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'status.name' -Values $Status
    }

    # Handle "user" field inputs, resolve names and email addresses to appropriate field
    if ($PSBoundParameters.ContainsKey('Technician')) {
        $TechParams = @{
            Values = $Technician
            Field = Resolve-UserField $Technician -Field 'technician'
        }
        if ($TechnicianLogicalOperator) {
            $Criteria += Format-ZohoCriteria @Shared @TechParams -Operator $TechnicianLogicalOperator             
        }
        else {
            $Criteria += Format-ZohoCriteria @Shared @TechParams            
        }
    }

    if ($PSBoundParameters.ContainsKey('Creator')) {
        $CreatorParams = @{
            Values = $Creator
            Field = Resolve-UserField $Creator -Field 'creator'
        }

        $Criteria += Format-ZohoCriteria @Shared @CreatorParams
    }

    if ($PSBoundParameters.ContainsKey('Requester')) {
        $RequesterParams = @{
            Values = $Requester
            Field = Resolve-UserField $Requester -Field 'requester'
        }

        $Criteria += Format-ZohoCriteria @Shared @RequesterParams
    }

    if ($PSBoundParameters.ContainsKey('Category')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'category.name' -Values $Category
    }

    if ($PSBoundParameters.ContainsKey('SubCategory')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'subcategory.name' -Values $SubCategory
    }

    if ($PSBoundParameters.ContainsKey('Item')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'item.name' -Values $Item
    }

    if ($PSBoundParameters.ContainsKey('Group')) {
        if ($GroupLogicalOperator) {
            $Criteria += Format-ZohoCriteria @Shared -Field 'group.name' -Values $Group -Operator $GroupLogicalOperator        
        }
        else {            
            $Criteria += Format-ZohoCriteria @Shared -Field 'group.name' -Values $Group
        }
    }

    if ($PSBoundParameters.ContainsKey('Department')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'department.name' -Values $Department
    }

    if ($PSBoundParameters.ContainsKey('Level')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'level.name' -Values $Level
    }

    if ($PSBoundParameters.ContainsKey('Priority')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'priority.name' -Values $Priority
    }

    if ($PSBoundParameters.ContainsKey('Urgency')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'urgency.name' -Values $Urgency
    }

    if ($PSBoundParameters.ContainsKey('Impact')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'impact.name' -Values $Impact
    }

    # Build output object
    $Criteria
}
