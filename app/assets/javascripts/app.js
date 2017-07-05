// Popover menu to select the type of work when starting a deposit
Hyrax.selectWorkType = function () {
        var EpigaeaSelectWorkType = require('epigaea/select_work_type')
        $("[data-behavior=select-work]").each(function () {
            new EpigaeaSelectWorkType($(this))
        })
}
