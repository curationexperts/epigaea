function gisBehavior() {
  $(function () {
    var geoNamesUsername = 'mkorcy';
// Instantiate the Bloodhound suggestion engine
    var places = new Bloodhound({
        datumTokenizer: function (datum) {
            return Bloodhound.tokenizers.whitespace(datum.name);
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
            // http://www.geonames.org/export/geonames-search.html
            url: 'https://mira.lib.tufts.edu/geonames/searchJSON?name=%QUERY&featureCode=PCL&featureCode=ADM1&featureCode=ADM2&featureCode=ADM2H&&featureCode=ADMD&' +
                'featureCode=PPL&featureCode=PPLS&featureCode=OCN&maxRows=12&username=' + geoNamesUsername + '&lang=en',
            wildcard: '%QUERY',
            filter: function (parsedResponse) {
                var result = [];
                for (var i = 0; i < parsedResponse.geonames.length; i++) {
                    var geonameId = parsedResponse.geonames[i].geonameId;
                    result.push({
                        name: parsedResponse.geonames[i].name,
                        value: parsedResponse.geonames[i].value,
                        geonameId: geonameId,
                        adminName1: parsedResponse.geonames[i].adminName1,
                        countryName: parsedResponse.geonames[i].countryName
                    });
                }
                return result;
            }
        }
    });

// Initialize the Bloodhound suggestion engine
    places.initialize();
    var $myTextarea = $('#geotextarea');


// Instantiate the Typeahead UI
    $('.geonames').typeahead(null, {
        displayKey: 'value',
        source: places.ttAdapter(),
        templates: {
            suggestion: Handlebars.compile('<div data-geoid="{{geonameId}}">{{name}} {{#if adminName1}}- {{/if}}{{adminName1}} {{#if countryName}}- {{/if}}{{countryName}}</div>')
        }
    });

    $('.geonames').on('typeahead:selected', function (item, datum, name) {
        var geoname = datum.name + (datum.adminName1 === '' || datum.adminName1 === undefined ? '' : (' -- ' + datum.adminName1)) + (datum.countryName === undefined || datum.countryName === '' ? '' : (' -- ' + datum.countryName));
        if ($myTextarea.text().indexOf(geoname) < 0) {
            $myTextarea.append('<button type="button" class="remove-geoname btn btn-default"><span class="glyphicon glyphicon-remove" aria-hidden="true">' +
                '<span class="pill" data-geoid="' + datum.geonameId + '">&nbsp;' + geoname + '</span>' +
                '<input type="hidden" name="contribution[geonames][]" value="' + geoname + '"/></span></button>');
        }
        return true;
    });

    $('body').on('click', '.remove-geoname', function (e) {
        $(e.target).closest('.btn').remove();
    });

    var createComboBox = function () {
        var select = $('#year');
        var selected_year = $('#year').data('selection');
        year = new Date().getFullYear() + 1;

        for (var i = 0; i < 10; i++) {
            var option = document.createElement("option");
            if (year === selected_year) {
                $(option).prop({selected: true});
            }
            select[0].appendChild(option).text = year;
            select[0].appendChild(option).value = year;
            year += -1
        }

    };
    createComboBox();

    $('.checkbox-inline .checkbox').addClass('checkbox-inline')


    /*** Dynamic selections ****/

    var topicDropdown = $("#topics"),
        themeDropdown = $('#themes'), // create a country dropdown
        themes = []; // ordered list of countries

    // parse the nested dropdown
    topicDropdown.children().each(function () {
        var group = $(this),
            themeName = group.attr('label'),
            option;

        // create an option for the country
        option = $('<option></option>').text(themeName);

        // store the associated city options
        option.data('topics', group.children());

        // check if the country should be selected
        if (group.find(':selected').length > 0) {
            option.prop('selected', true);
        }

        // add the country to the dropdown
        themeDropdown.append(option);
    });

    function updateTopics() {
        var theme = themeDropdown.find(':selected');
        topicDropdown.empty().append(theme.data('topics'));
    }

    // call the function to set the initial cities
    updateTopics();

    // and add the change handler
    themeDropdown.on('change', updateTopics);

    $('#topics').on('change', function (e) {
        if (e.target.value != '') {
            var theme = $('#themes').val() + ' -- ' + e.target.value;
            if ($('#categories_textarea').text().indexOf(theme) < 0) {
                $('#categories_textarea').append('<button type="button" class="remove-geoname btn btn-default"><span class="glyphicon glyphicon-remove" aria-hidden="true">' +
                    '<span class="pill">&nbsp;' + theme + '</span><input type="hidden" name="contribution[topics][]" value="' + theme + '">' +
                    '</span></button>');
            }
        }
        return true;
    });

    $('#department_picker div.checkbox').wrapAll('<div class="checkbox-overflow"/>');

    $(':input[required=""],:input[required]').siblings().addClass('required');

});
}
