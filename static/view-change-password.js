$('ready turbolinks:load').ready(function() {
    $("#filterInput").on("keyup", function() {        
        const value = $(this).val().toLowerCase();
        $(".data-table tbody tr").filter(function() {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
    

    /* var openModal = $('#flight-pilot-tab');
    var close = $('#profile, #flights-dispetcher-tab, #flight-stewardess-tab, #accounting-tab');

    openModal.click( function(){//Открытие настроек
        $('#settingModal').show().animate();
    });

    close.click( function(){//Закрытие настроек
        $('#settingModal').hide();
    }); */

    $('.data-table tr').on('click', function() {
        if($(this).hasClass('marked')) {
            $(this).removeClass('marked');
            $(this).attr('name', "empList")
        } else {
            $(this).addClass('marked');
            $(this).attr('name', "empList")
        }
    });

    $('.data-table tr').dblclick(function() {
        window.location = $(this).attr("href")
    })
});

/* function downloadObjectAsJson(exportObj, exportName){
    var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(exportObj));
    var downloadAnchorNode = document.createElement('a');
    downloadAnchorNode.setAttribute("href",     dataStr);
    downloadAnchorNode.setAttribute("download", exportName + ".json");
    document.body.appendChild(downloadAnchorNode); // required for firefox
    downloadAnchorNode.click();
    downloadAnchorNode.remove();
  }
 */