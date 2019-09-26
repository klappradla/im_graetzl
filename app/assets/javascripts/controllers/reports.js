APP.controllers.reports = (function() {

    function init() {
      if($('#admin-report').exists()) initReports();
    }


    // ---------------------------------------------------------------------- Public
    
    // REPORTS INIT
    var initReports = function initReports() {
      /*********************************
          Init Vars
      *********************************/
      moment.locale("de-at");
      var chartTopArea; // Top Chart Area for Line-Charts

      var chartGraetzlTopArea; // Top Chart Area for Pie-Chart

      var users = []; // Clean Users Array to work with

      var usersearch = []; // User Serach Result

      var rooms = []; // Clean Room Array to work with

      var meetings = []; // Clean Meetings Array to work with

      var graetzls = []; // Clean Grätzl Array to work with

      var locations = []; // Clean Location Array to work with

      var mc_automations = []; // Mailchimp Automation Mailings

      var host = "http://" + window.location.host + "/"; // Environment Path

      var host_admin = "http://" + window.location.host + "/admin/"; // Active Admin Path
      // Date Params for Ajax Requests

      var ajaxStartDate = "&q%5Bcreated_at_gteq_datetime%5D=";
      var ajaxEndDate = "&q%5Bcreated_at_lteq_datetime%5D="; // Mailchimp Chart

      var mcChartData = {
        labels: [],
        data: {
          emails_sent: [],
          unique_opens: [],
          unique_clicks: []
        }
      }; // Grätzl Activity Counts for Charts

      var graetzls_count; // Room Type Translation

      var room_type = {
        offering_room: "Habe Raum",
        offering_roommate: "Habe Raum - Neu anmieten",
        seeking_room: "Suche Raum",
        seeking_roommate: "Suche Raum - Neu anmieten"
      };
      /*********************************
           Loading Spinner
       *********************************/
      // Show & Stop Loading Spinner //

      var showSpinner = function showSpinner() {
        //loading-spinner
        //var spinnerSrc = "<%= asset_path('svg/loading.svg') %>";
        //var spinner = $('<img class="loading-spinner" src="' + spinnerSrc + '">');
        var spinner = $("footer .loading-spinner")
          .clone()
          .removeClass("-hidden");
        $("#topLineChart").hide();
        $("#topPieChart").hide();
        $("#top").append(spinner);
      };

      var stopSpinner = function stopSpinner(page) {
        if (page == "page_graetzls") {
          $("#topPieChart").show();
        } else {
          $("#topLineChart").show();
        }

        $("#top")
          .find(".loading-spinner")
          .remove();
      };
      /*********************************
           TimeTable Object for Charts
       *********************************/

      var initDate = new Date();
      var initUnit = "days"; // Option for Units

      var initPeriod = 30; // Option for Setting Default Time Period

      var TimeChart = function TimeChart(end, period) {
        (this.end = end),
          (this.period = period),
          (this.unit = "days"),
          (this.dates = []),
          (this.datesFriendly = []),
          (this.data = []), // Set End Date to Midnight
          (this.endDate = function() {
            date = new Date(this.end); //date.setDate(date.getDate() + 1 );

            date.setHours(23, 59, 59, 0);
            return date;
          }); // Set Start Date - > Use 0 for First of Month or Set Time Period

        this.startDate = function() {
          // Set StartDate dependent on Period
          if (this.period != 0) {
            var date = new Date(this.end);
            date.setDate(this.endDate().getDate() - this.period + 1);
            date.setHours(0, 0, 0, 0);
            return date; // Set StartDate to 1. od EndDate Month
          } else {
            var date = new Date(this.end);
            date.setDate(1);
            date.setHours(0, 0, 0, 0);
            return date;
          }
        }; // Fill Dates and Friendly-Dates Array with Date-Values

        this.setTimeUnit = function() {
          if (this.unit == "days") {
            for (
              i = this.startDate();
              i <= this.endDate();
              i.setDate(i.getDate() + 1)
            ) {
              //var tzoffset = (new Date()).getTimezoneOffset() * 60000; //offset in milliseconds - Summer/Winter
              //var priorDate = new Date(i - tzoffset).toISOString().slice(0,10);
              var priorDate = convertDateToISOString(i);
              var priorDateFriendly = moment(i).format("ll");
              this.dates.push(priorDate);
              this.datesFriendly.push(priorDateFriendly);
            }
          }
        }; // Timeline Array

        this.setTimeUnit(); // Immediate Init Function-Call
        // Fill Chart Data & Draw Chart

        this.drawChart = function(type, label) {
          this.data.length = this.dates.length; // Set Length of Time Period Array

          this.data.fill(0); // Prefill all Values with 0

          for (i = 0; i < type.length; i++) {
            var checkDate = new Date(type[i].created_at).toISOString().slice(0, 10);

            if (
              checkDate >= this.dates[0] &&
              checkDate <= this.dates[this.dates.length - 1]
            ) {
              var pos = this.dates.indexOf(checkDate);
              this.data[pos] += 1; // Set and add Value at correct Position
            }
          } // Draw Chart
          //console.log(this.period);
          //console.log(this.startDate());
          //console.log(this.endDate());

          chartTopArea = new Chart(topchart, {
            type: "line",
            data: {
              labels: this.datesFriendly,
              datasets: [
                {
                  label: label,
                  data: this.data,
                  //backgroundColor : 'rgba(237, 129, 117, 0.2)',
                  borderWidth: 1
                }
              ]
            },
            options: {
              scales: {
                yAxes: [
                  {
                    ticks: {
                      min: 0,
                      stepSize: 2
                    }
                  }
                ]
              },
              legend: {
                display: true,
                labels: {
                  fontSize: 16,
                  fontStyle: "bold"
                }
              }
            }
          });
        }; // Get Users and Set Clean User Array

        this.requestUsers = function() {
          return new Promise(
            function(resolve, reject) {
              var startDate = convertDateToISOString(this.startDate());
              var endDate = convertDateToISOString(this.endDate()); //console.log(startDate);
              //console.log(endDate);

              $.ajax({
                url:
                  "/admin/users.json?" +
                  ajaxStartDate +
                  startDate +
                  ajaxEndDate +
                  endDate,
                method: "GET",
                success: function success(response) {
                  //console.log(response);
                  users = [];

                  for (i = 0; i < response.length; i++) {
                    users.push({
                      id: response[i].id,
                      graetzl_id: response[i].graetzl_id,
                      graetzl_name: "",
                      graetzl_app_path: "",
                      created_at: new Date(response[i].created_at),
                      username: response[i].username,
                      first_name: response[i].first_name,
                      last_name: response[i].last_name,
                      email: response[i].email,
                      user_path_admin: host_admin + "users/" + response[i].slug,
                      user_path_app: host + response[i].slug,
                      role: response[i].role,
                      districts: [],
                      locations: []
                    });
                  }

                  completeUser(users);
                  resolve("users");
                }
              });
            }.bind(this)
          );
        }; // Get Users
        // Get Locations and Set Clean Location Array

        this.requestLocations = function() {
          return new Promise(
            function(resolve, reject) {
              var startDate = convertDateToISOString(this.startDate());
              var endDate = convertDateToISOString(this.endDate()); //var startDate = this.startDate().toISOString().slice(0, 10);
              //var endDate = this.endDate().toISOString().slice(0, 10);

              $.ajax({
                url:
                  "/admin/locations.json?" +
                  ajaxStartDate +
                  startDate +
                  ajaxEndDate +
                  endDate,
                method: "GET",
                success: function success(response) {
                  locations = [];

                  for (i = 0; i < response.length; i++) {
                    // Push to Locations Array
                    locations.push({
                      id: response[i].id,
                      name: response[i].name,
                      created_at: response[i].created_at,
                      graetzl_id: response[i].graetzl_id,
                      graetzl_name: "",
                      category_id: response[i].location_category_id,
                      state: response[i].state,
                      user_ids: response[i].user_ids,
                      location_path: response[i].slug,
                      location_path_admin:
                        host_admin + "locations/" + response[i].slug
                    }); // Extend Location Array with Grätzl-Infos from Grätzl Array

                    var res = fetchFromID(locations[i].graetzl_id, "graetzls");

                    for (var key in res) {
                      locations[i].graetzl_name = res[key].name;
                      locations[i].location_path =
                        res[key].graetzl_app_path +
                        "/locations/" +
                        locations[i].location_path;
                    }
                  }

                  resolve("locations");
                }
              });
            }.bind(this)
          );
        }; // Get Locations
        // Get Meetings and Set Clean Meeting Array

        this.requestMeetings = function() {
          return new Promise(
            function(resolve, reject) {
              var startDate = convertDateToISOString(this.startDate());
              var endDate = convertDateToISOString(this.endDate()); //var startDate = this.startDate().toISOString().slice(0, 10);
              //var endDate = this.endDate().toISOString().slice(0, 10);

              $.ajax({
                url:
                  "/admin/meetings.json?" +
                  ajaxStartDate +
                  startDate +
                  ajaxEndDate +
                  endDate,
                method: "GET",
                success: function success(response) {
                  meetings = [];

                  for (i = 0; i < response.length; i++) {
                    // Push to Meetings Array
                    meetings.push({
                      id: response[i].id,
                      name: response[i].name,
                      created_at: response[i].created_at,
                      graetzl_id: response[i].graetzl_id,
                      graetzl_name: "",
                      user_id: response[i].user_id,
                      meeting_path: response[i].slug,
                      meetings_path_admin:
                        host_admin + "meetings/" + response[i].slug
                    }); // Extend Location Array with Grätzl-Infos from Grätzl Array

                    var res = fetchFromID(meetings[i].graetzl_id, "graetzls");

                    for (var key in res) {
                      meetings[i].graetzl_name = res[key].name;
                      meetings[i].meetings_path =
                        res[key].graetzl_app_path +
                        "/treffen/" +
                        meetings[i].meetings_path;
                    }
                  }

                  resolve("meetings");
                }
              });
            }.bind(this)
          );
        }; // Get Locations
        // Get Rooms and Set Clean Rooms Array

        this.requestRooms = function(type) {
          return new Promise(
            function(resolve, reject) {
              var startDate = convertDateToISOString(this.startDate());
              var endDate = convertDateToISOString(this.endDate()); //var startDate = this.startDate().toISOString().slice(0, 10);
              //var endDate = this.endDate().toISOString().slice(0, 10);

              $.ajax({
                url:
                  "/admin/" +
                  type +
                  ".json?" +
                  ajaxStartDate +
                  startDate +
                  ajaxEndDate +
                  endDate,
                method: "GET",
                success: function success(response) {
                  //console.log(response);
                  for (i = 0; i < response.length; i++) {
                    // Push to Rooms Array
                    rooms.push({
                      id: response[i].id,
                      name: response[i].slogan,
                      created_at: response[i].created_at,
                      graetzl_id: response[i].graetzl_id,
                      user_id: response[i].user_id,
                      room_path: response[i].slug,
                      room_path_admin: host_admin + type + "/" + response[i].slug,
                      category_ids: response[i].room_category_ids,
                      type: response[i].offer_type
                        ? response[i].offer_type
                        : response[i].demand_type,
                      type_friendly: response[i].offer_type
                        ? room_type[response[i].offer_type]
                        : room_type[response[i].demand_type],
                      // Translate from Object room_type,
                      district_ids: response[i].district_id
                        ? [response[i].district_id]
                        : response[i].district_ids
                    });
                  }

                  resolve("rooms");
                }
              });
            }.bind(this)
          );
        }; // Get Rooms
      }; // Chart Object

      /*********************************
           USER OBJECT
       *********************************/

      var User = function User(id) {
        (this.id = id), // User Content
          (this.districts = []),
          (this.locations = []),
          (this.updates = []),
          (this.meetings = []),
          (this.rooms = []), // Get User Infos from Server
          (this.getUser = function() {
            return new Promise(
              function(resolve, reject) {
                $.ajax({
                  url: "/admin/users/" + this.id + ".json",
                  method: "GET",
                  success: function(res) {
                    //console.log(res);
                    this.role = res.role;
                    this.newsletter = res.newsletter;
                    this.created_at = new Date(res.created_at);
                    this.last_login = res.updated_at
                      ? new Date(res.updated_at)
                      : "";
                    this.username = res.username;
                    this.slug = res.slug;
                    this.user_path_admin = host_admin + "users/" + res.slug;
                    this.user_path_app = host + res.slug;
                    this.first_name = res.first_name;
                    this.last_name = res.last_name;
                    this.email = res.email;
                    this.website = res.website;
                    this.avatar = res.avatar;
                    this.graetzl_id = res.graetzl_id;
                    this.getGraetzlInfos(); // Get Grätzl Infos from Grätzl-Array

                    resolve("user");
                  }.bind(this)
                });
              }.bind(this)
            );
          }); // getUser Infos from Server
        // Get User Locations from Server

        this.getLocations = function() {
          return new Promise(
            function(resolve, reject) {
              $.ajax({
                url:
                  "/admin/locations.json?q%5Blocation_ownerships_user_id_eq%5D=" +
                  this.id,
                method: "GET",
                success: function(res) {
                  for (i = 0; i < res.length; i++) {
                    this.locations.push({
                      id: res[i].id,
                      name: res[i].name,
                      slogan: res[i].slogan,
                      slug: res[i].slug,
                      state: res[i].state,
                      graetzl_id: res[i].graetzl_id,
                      graetzl_name: "",
                      category_id: res[i].location_category_id,
                      created_at: new Date(res[i].created_at),
                      location_path: "",
                      location_path_admin: host_admin + "locations/" + res[i].slug
                    });
                  } // Get missing Location Infos from Grätzl Array

                  for (i = 0; i < this.locations.length; i++) {
                    res = fetchFromID(this.locations[i].graetzl_id, "graetzls");

                    for (var key in res) {
                      this.locations[i].graetzl_name = res[key].name;
                      this.locations[i].location_path =
                        res[key].graetzl_app_path +
                        "/locations/" +
                        this.locations[i].slug;
                    }
                  }

                  resolve("user_location");
                }.bind(this)
              });
            }.bind(this)
          );
        }; // get User Locations from Server
        // Get Location Updates for each User Location from Server
        // Has bug: Gets only Updates from first Location

        this.getLocationUpdates = function() {
          if (this.locations.length == 0) {
            return;
          } else {
            return new Promise(
              function(resolve, reject) {
                $.ajax({
                  url:
                    "/admin/location_posts.json?q%5Bauthor_id_eq%5D=" +
                    this.locations[0].id,
                  method: "GET",
                  success: function(res) {
                    //console.log(res);
                    for (i = 0; i < res.length; i++) {
                      this.updates.push({
                        id: res[i].id,
                        location_id: res[i].author_id,
                        title: res[i].title,
                        slug: res[i].slug,
                        graetzl_id: res[i].graetzl_id,
                        graetzl_name: "",
                        created_at: new Date(res[i].created_at),
                        update_path: "",
                        update_path_admin:
                          host_admin + "location_posts/" + res[i].slug
                      });
                    } // Get missing Location Infos from Grätzl Array

                    for (i = 0; i < this.updates.length; i++) {
                      res = fetchFromID(this.updates[i].graetzl_id, "graetzls");

                      for (var key in res) {
                        this.updates[i].graetzl_name = res[key].name;
                      }
                    }

                    resolve("user_updates");
                  }.bind(this)
                });
              }.bind(this)
            );
          } // get User Locations from Server
        }; // Get User Meetings from Server

        this.getMeetings = function() {
          return new Promise(
            function(resolve, reject) {
              // TO DO :: INITIATOR STATT GOINGTOs
              $.ajax({
                url: "/admin/meetings.json?q%5Bgoing_tos_user_id_eq%5D=" + this.id,
                method: "GET",
                success: function(res) {
                  for (i = 0; i < res.length; i++) {
                    this.meetings.push({
                      id: res[i].id,
                      name: res[i].name,
                      created_at: res[i].created_at,
                      graetzl_id: res[i].graetzl_id,
                      graetzl_name: "",
                      user_id: res[i].user_id,
                      meetings_path: res[i].slug,
                      meetings_path_admin: host_admin + "meetings/" + res[i].slug
                    });
                  } // Get missing Location Infos from Grätzl Array

                  for (i = 0; i < this.meetings.length; i++) {
                    res = fetchFromID(this.meetings[i].graetzl_id, "graetzls");

                    for (var key in res) {
                      this.meetings[i].graetzl_name = res[key].name;
                      this.meetings[i].meetings_path =
                        res[key].graetzl_app_path +
                        "/treffen/" +
                        this.meetings[i].meetings_path;
                    }
                  }

                  resolve("user_meetings");
                }.bind(this)
              });
            }.bind(this)
          );
        }; // get User Meetings from Server
        // Get User Rooms from Server

        this.getRooms = function(type) {
          return new Promise(
            function(resolve, reject) {
              $.ajax({
                url: "/admin/" + type + ".json?q%5Buser_id_eq%5D=" + this.id,
                method: "GET",
                success: function(response) {
                  //console.log(response);
                  for (i = 0; i < response.length; i++) {
                    // Push to User Rooms Array
                    this.rooms.push({
                      id: response[i].id,
                      name: response[i].slogan,
                      created_at: response[i].created_at,
                      graetzl_id: response[i].graetzl_id,
                      user_id: response[i].user_id,
                      room_path: response[i].slug,
                      room_path_admin: host_admin + type + "/" + response[i].slug,
                      category_ids: response[i].room_category_ids,
                      type: response[i].offer_type
                        ? response[i].offer_type
                        : response[i].demand_type,
                      type_friendly: response[i].offer_type
                        ? room_type[response[i].offer_type]
                        : room_type[response[i].demand_type],
                      // Translate from Object room_type,
                      district_ids: response[i].district_id
                        ? [response[i].district_id]
                        : response[i].district_ids
                    });
                  }

                  resolve("user rooms");
                }.bind(this)
              });
            }.bind(this)
          );
        }; // get User Rooms from Server
        // Get Grätzls & District Infos for User from Grätzl-Array

        this.getGraetzlInfos = function() {
          res = fetchFromID(this.graetzl_id, "graetzls");

          for (var key in res) {
            // Set Grätzl Infos
            this.graetzl_name = res[key].name;
            this.graetzl_app_path = res[key].graetzl_app_path; // Set District Infos

            for (d = 0; d < res[key].districts.length; d++) {
              this.districts.push({
                id: res[key].districts[d].id,
                name: res[key].districts[d].name,
                slug: res[key].districts[d].slug,
                zip: res[key].districts[d].zip
              });
            }
          }
        }.bind(this); // Get Grätzls & District Infos
        // Get Mailchimp User Infos

        this.getMailings = function() {
          return new Promise(
            function(resolve, reject) {
              $.ajax({
                url: "/reports/mailchimp.json",
                data: {
                  count: 100,
                  email: this.email,
                  activity: "activity"
                },
                method: "GET",
                success: function success(response) {
                  resolve(response);
                }
              });
            }.bind(this)
          );
        }; // Get Mailchimp User Infos
      }; // USER OBJECT

      /*********************************
           Page Navigation
       *********************************/

      var page_loader = function page_loader(page, info) {
        // Show Page and Stop Spinner
        $("div.page").hide(); // Hide all Pages

        $("#" + page + "").show(); // Show Specific Page

        $("#report_nav button").prop("disabled", false); // Load Page Specific Content

        if (page == "page_users") {
          resetTopChart();
          showSpinner();
          var usersChart = new TimeChart(initDate, initPeriod);
          Promise.resolve(usersChart.requestUsers()).then(function(res) {
            usersChart.drawChart(users, "" + users.length + " User");
            stopSpinner(); // If Search, load Searchresult, else normal Usertable

            info
              ? datatable_users(usersearch, "users")
              : datatable_users(users, "users");
          });
        }

        if (page == "page_locations") {
          resetTopChart();
          showSpinner();
          var locationsChart = new TimeChart(initDate, initPeriod);
          Promise.resolve(locationsChart.requestLocations()).then(function(res) {
            locationsChart.drawChart(
              locations,
              "" + locations.length + " Locations"
            );
            stopSpinner();
            datatable_locations();
          });
        }

        if (page == "page_meetings") {
          resetTopChart();
          showSpinner();
          var meetingsChart = new TimeChart(initDate, initPeriod);
          Promise.resolve(meetingsChart.requestMeetings()).then(function(res) {
            meetingsChart.drawChart(meetings, "" + meetings.length + " Treffen");
            stopSpinner();
            datatable_meetings();
          });
        }

        if (page == "page_rooms") {
          resetTopChart();
          showSpinner();
          var roomsChart = new TimeChart(initDate, initPeriod);
          rooms = [];
          var p1 = Promise.resolve(roomsChart.requestRooms("room_offers"));
          var p2 = Promise.resolve(roomsChart.requestRooms("room_demands"));
          Promise.all([p1, p2]).then(function(res) {
            roomsChart.drawChart(rooms, "" + rooms.length + " Raumteiler");
            stopSpinner();
            datatable_rooms(); //console.log(rooms);
          });
        }

        if (page == "page_graetzls") {
          resetTopChart();
          showSpinner();

          if (info == true) {
            var usersChart = new TimeChart(initDate, initPeriod);
            Promise.resolve(usersChart.requestUsers()).then(function(res) {
              completeGraetzls(users);
              setGraetzlChartData("actual");
              graetzlsChart("actual");
              stopSpinner(page);
              datatable_graetzls();
            });
          } else {
            completeGraetzls(users);
            setGraetzlChartData("actual");
            graetzlsChart("actual");
            stopSpinner(page);
            datatable_graetzls();
          }
        }

        if (page == "page_mailings") {
          resetTopChart();
          showSpinner();
          datatable_mailings("automations");
          stopSpinner();
        }
      }; // END Page Navigation //
      // Create Monthly Navigation Dropdown

      var setTimeNav = function setTimeNav() {
        var actualmonth = moment(new Date());
        $("#months")
          .find("option")
          .remove(); // Set actual last 30 Days

        $(
          '<option data-unit="days" data-day="' +
            actualmonth.format("YYYY-MM-DD") +
            '" data-period="' +
            initPeriod +
            '">Letzten ' +
            initPeriod +
            " Tage</option>"
        ).appendTo("#months");

        for (i = 0; i < 13; i++) {
          var prevMonth = moment(actualmonth).subtract(i, "months");
          var prevMonthLast = prevMonth.endOf("month").format("YYYY-MM-DD");
          $(
            '<option data-unit="months" data-day="' +
              prevMonthLast +
              '">' +
              prevMonth.format("MMMM YYYY") +
              "</option>"
          ).appendTo("#months");
        }
      };
      /*********************************
          Init on Document Ready
      *********************************/

      $(document).ready(function() {
        // Init Chartarea
        var topchart = $("#topchart");
        var graetzlchart = $("#graetzlchart"); // Init Month Navigation Dropdown

        setTimeNav(); // Hide Pages on Load

        $("div.page").hide();
        $("#report_nav button.pages").prop("disabled", true);
        showSpinner(); // Load Grätzls on Pageload

        Promise.resolve(requestGraetzls()).then(function(res) {
          page_loader("page_users"); //console.log(graetzls);
        }); //.catch( function() {alert('Error Loading Data ...'); } )
      });
      /*********************************
          HELPER Functions
      *********************************/
      // Convert Date to ISO String with correct TimeZone

      var convertDateToISOString = function convertDateToISOString(date) {
        var tzoffset = date.getTimezoneOffset() * 60000; //offset in milliseconds - Summer/Winter

        return new Date(date - tzoffset).toISOString().slice(0, 10);
      }; // Math Round for Percentage

      var round = function round(wert, dez) {
        wert = parseFloat(wert);
        if (!wert) return 0;
        dez = parseInt(dez);
        if (!dez) dez = 0;
        var umrechnungsfaktor = Math.pow(10, dez);
        return Math.round(wert * umrechnungsfaktor) / umrechnungsfaktor;
      }; // Reset Top Chart

      var resetTopChart = function resetTopChart() {
        if (typeof chartTopArea != "undefined") {
          chartTopArea.destroy();
        }

        if (typeof chartGraetzlTopArea != "undefined") {
          chartGraetzlTopArea.destroy();
        }
      }; // Helper - Lookup in other Array over ID

      var fetchFromID = function fetchFromID(id, type) {
        if (type == "graetzls") {
          var result = graetzls.filter(function(e) {
            return e.id == id;
          });
          return result;
        }

        if (type == "locations") {
          var result = locations.filter(function(e) {
            return e.user_ids == id;
          });
          return result;
        }

        if (type == "users") {
          var result = users.filter(function(e) {
            return e.id == id;
          });
          return result;
        }
      };

      var showmore = function showmore(type) {
        event.preventDefault();
        var dataid = type; //console.log(dataid)

        var vis = $("#" + dataid + " div:visible")
          .last()
          .index();
        $("#" + dataid + " div")
          .slice(vis, vis + 4)
          .show();
      }; // Helper - Complete User Array with missing Infos from Grätzl Arrays

      var completeUser = function completeUser(type) {
        // Extend User Array with Grätzl-Infos
        for (i = 0; i < type.length; i++) {
          res = fetchFromID(type[i].graetzl_id, "graetzls");

          for (var key in res) {
            // Get Grätzl Infos
            type[i].graetzl_name = res[key].name;
            type[i].graetzl_app_path = res[key].graetzl_app_path; // Get District Infos

            for (d = 0; d < res[key].districts.length; d++) {
              type[i].districts.push({
                id: res[key].districts[d].id,
                name: res[key].districts[d].name,
                slug: res[key].districts[d].slug,
                zip: res[key].districts[d].zip
              });
            }
          }
        }
      }; // Helper - Complete Grätzl Array with Userscount from actual Timeperiod

      var completeGraetzls = function completeGraetzls(type) {
        //  Set users_count_actual_timeperiod of all Graetzls to 0
        for (i = 0; i < graetzls.length; i++) {
          graetzls[i].users_count_actual_timeperiod = 0;
        } // Extend Graetzl Array with Usercount Info

        for (i = 0; i < type.length; i++) {
          res = fetchFromID(type[i].graetzl_id, "graetzls");

          for (var key in res) {
            var matchGraetzl = graetzls.find(function(matchGraetzl) {
              return matchGraetzl.id === type[i].graetzl_id;
            });
            matchGraetzl.users_count_actual_timeperiod += 1; // Set Sum of GraetzlUsers in TimePeriod
          }
        }
      }; // Helper Function for Filling Graetzl Chart Data

      var setGraetzlChartData = function setGraetzlChartData(type) {
        // Reset Arrays
        graetzls_count = {
          total: {
            sum: 0,
            //sumTopGraetzl:0,
            data: [],
            chartData: [],
            chartLabel: []
          },
          actual: {
            sum: 0,
            //sumTopGraetzl:0,
            data: [],
            chartData: [],
            chartLabel: []
          }
        };

        if (type == "total") {
          type = graetzls_count.total;

          for (i = 0; i < graetzls.length; i++) {
            type.sum += graetzls[i].users_count;
            type.data.push({
              label: graetzls[i].name,
              count: graetzls[i].users_count
            });
          }
        } else if (type == "actual") {
          type = graetzls_count.actual;

          for (i = 0; i < graetzls.length; i++) {
            type.sum += graetzls[i].users_count_actual_timeperiod;
            type.data.push({
              label: graetzls[i].name,
              count: graetzls[i].users_count_actual_timeperiod
            });
          }
        } //console.log(type);
        // Sort Array by Count-Value

        type.data.sort(function(a, b) {
          return a.count < b.count ? 1 : b.count < a.count ? -1 : 0;
        }); // Push Data in Chart Arrays

        for (i = 0; i < type.data.length; i++) {
          type.chartData.push(type.data[i].count);
          type.chartLabel.push(
            type.data[i].label + " (" + type.data[i].count + ")"
          );
        }
      }; //Graetzl Chart Data
      // Helper Functions

      /*********************************
           AJAX
          JSON Requests
       *********************************/
      // Get Grätzls and Set Clean Grätzl Array

      function requestGraetzls() {
        return new Promise(function(resolve, reject) {
          $.ajax({
            // Reuquest Grätzl Data just with Users -> Performance
            url: "/admin/graetzls.json?q%5Busers_count_greater_than%5D=0",
            method: "GET",
            success: function success(response) {
              //console.log(response);
              for (i = 0; i < response.length; i++) {
                graetzls.push({
                  id: response[i].id,
                  name: response[i].name,
                  graetzl_app_path: host + response[i].slug,
                  graetzl_admin_path: host_admin + "graetzls/" + response[i].slug,
                  users_count: response[i].users_count,
                  districts: [],
                  users_count_actual_timeperiod: 0
                }); // Add Districts to Grätzl

                for (d = 0; d < response[i].districts.length; d++) {
                  graetzls[i].districts.push({
                    id: response[i].districts[d].id,
                    name: response[i].districts[d].name,
                    slug: response[i].districts[d].slug,
                    zip: response[i].districts[d].zip
                  });
                }
              }

              resolve("graetzls");
            }
          });
        });
      } // Get Grätzls
      // Get Mailchimp Automations

      var requestMCAutomations = function requestMCAutomations(type, workflow_id) {
        return new Promise(function(resolve, reject) {
          $.ajax({
            url: "/reports/mailchimp.json",
            data: {
              count: 100,
              type: type,
              workflow: workflow_id
            },
            method: "GET",
            success: function success(response) {
              resolve(response);
            }
          });
        });
      }; // Get Mailchimp Automations
      // Search Request for Users

      var requestUserSearch = function requestUserSearch(email, id) {
        // Emtpy Search Result Array
        usersearch = [];
        return new Promise(function(resolve, reject) {
          $.ajax({
            url: "/admin/users.json?q%5Bemail_contains%5D=" + email,
            method: "GET",
            success: function success(response) {
              for (i = 0; i < response.length; i++) {
                usersearch.push({
                  id: response[i].id,
                  graetzl_id: response[i].graetzl_id,
                  graetzl_name: "",
                  graetzl_app_path: "",
                  created_at: new Date(response[i].created_at),
                  username: response[i].username,
                  first_name: response[i].first_name,
                  last_name: response[i].last_name,
                  email: response[i].email,
                  user_path_admin: host_admin + "users/" + response[i].slug,
                  user_path_app: host + response[i].slug,
                  role: response[i].role,
                  districts: [],
                  locations: []
                });
              }

              completeUser(usersearch);
              resolve("usersearch");
            }
          });
        });
      }; // Search for User
      // END Ajax JSON Requests //

      /*********************************
           Create DATATABLES
          (jQuery Plugin)
       *********************************/
      // Create DATATABLE - USERS //

      var datatable_users = function datatable_users(type, name) {
        $("#datatable_" + name + "").DataTable({
          data: type,
          order: [[4, "desc"]],
          processing: true,
          paging: false,
          destroy: true,
          searching: false,
          //"responsive": true,
          columns: [
            //{ data: 'id' },
            {
              className: "details-control",
              orderable: false,
              data: null,
              defaultContent: ""
            },
            {
              data: "username",
              render: function render(data, type, row, meta) {
                if (type === "display") {
                  data =
                    '<a class="user" data-id="' +
                    row["id"] +
                    '" href="' +
                    row["user_path_admin"] +
                    '">' +
                    data +
                    "</a>";
                }

                return data;
              }
            },
            {
              data: "email"
            },
            /*
          { data: 'districts',
            render: function( data, type, row, meta ){
                if (row['districts'].length == 2){
                  data = row['districts'][0].zip + ', ' + row['districts'][1].zip;
                } else {
                  data = row['districts'][0].zip;
                }
              return data;
             }
          },*/
            {
              data: "graetzl_name",
              render: function render(data, type, row, meta) {
                if (type === "display") {
                  data =
                    '<a href="' +
                    row["graetzl_app_path"] +
                    '" target="_blank">' +
                    data +
                    "</a>";
                }

                return data;
              }
            },
            {
              data: "created_at",
              render: function render(data, type) {
                if (type == "sort" || type == "type") {
                  return data;
                } else {
                  // Use Friendly Format for Output
                  return moment(data).format("lll");
                }
              }
            }
          ]
        });
      }; // Data Table - User Detail Row

      function userDetails(data) {
        var $content = $('<div id="user' + data.id + '">');
        $($content).append(
          "<div>" + data.first_name + " " + data.last_name + "</div>"
        );
        $($content).append("<div>" + data.email + "</div>");
        return $content;
      } // Create DATATABLE - Mailchimp Automations //

      var datatable_mailings = function datatable_mailings(page) {
        if (page == "automations") {
          // Clear Array Data
          mc_automations = [];
          mcChartData = {
            labels: [],
            data: {
              emails_sent: [],
              unique_opens: [],
              unique_clicks: []
            }
          };
          var mcAutomations = requestMCAutomations("automations");
          Promise.resolve(mcAutomations).then(function(res) {
            var response = res.body.automations;

            for (i = 0; i < response.length; i++) {
              // Data Array for Datatable
              mc_automations.push({
                id: response[i].id,
                titel: response[i].settings.title,
                emails_sent: response[i].emails_sent,
                unique_opens: response[i].report_summary.unique_opens,
                unique_clicks: response[i].report_summary.subscriber_clicks,
                open_rate: round(response[i].report_summary.open_rate * 100, 1),
                click_rate: round(response[i].report_summary.click_rate * 100, 1)
              }); // Data Array for Chart

              mcChartData.labels.push(response[i].settings.title);
              mcChartData.data.emails_sent.push(response[i].emails_sent);
              mcChartData.data.unique_opens.push(
                response[i].report_summary.unique_opens
              );
              mcChartData.data.unique_clicks.push(
                response[i].report_summary.subscriber_clicks
              );
            } // Draw Chart

            mailingChart(
              mcChartData.labels,
              mcChartData.data.emails_sent,
              mcChartData.data.unique_opens,
              mcChartData.data.unique_clicks
            ); // Create Table

            datatable_mc_automations();
          });
        }
      }; // Draw DATATABLE - Mailchimp Automations //

      var datatable_mc_automations = function datatable_mc_automations() {
        $("#datatable_mailings").DataTable({
          data: mc_automations,
          order: [[1, "desc"]],
          processing: true,
          searching: false,
          paging: false,
          bDestroy: true,
          columns: [
            {
              data: "titel"
            },
            {
              data: "emails_sent"
            },
            {
              data: "unique_opens",
              render: function render(data, type, row, meta) {
                if (type === "display") {
                  data = data + " <small>(" + row["open_rate"] + "%)</small>";
                }

                return data;
              }
            },
            {
              data: "unique_clicks",
              render: function render(data, type, row, meta) {
                if (type === "display") {
                  data = data + " <small>(" + row["click_rate"] + "%)</small>";
                }

                return data;
              }
            }
          ]
        });
      }; // Create DATATABLE - GRÄTZLS //

      var datatable_graetzls = function datatable_graetzls() {
        $("#datatable_graetzls").DataTable({
          data: graetzls,
          order: [[3, "desc"]],
          processing: true,
          paging: false,
          bDestroy: true,
          searching: false,
          columns: [
            {
              data: "districts",
              render: function render(data, type, row, meta) {
                if (row["districts"].length == 2) {
                  data = row["districts"][0].zip + ", " + row["districts"][1].zip;
                } else {
                  data = row["districts"][0].zip;
                }

                return data;
              }
            },
            {
              data: "name"
            },
            {
              data: "users_count"
            },
            {
              data: "users_count_actual_timeperiod"
            }
          ]
        });
      }; // Create DATATABLE LOCATIONS

      var datatable_locations = function datatable_locations() {
        $("#datatable_locations").DataTable({
          data: locations,
          order: [[3, "desc"]],
          processing: true,
          paging: false,
          bDestroy: true,
          searching: false,
          columns: [
            {
              data: "id"
            },
            {
              data: "name",
              render: function render(data, type, row, meta) {
                if (type === "display") {
                  data =
                    '<a href="' +
                    row["location_path_admin"] +
                    '" target="_blank">' +
                    data +
                    "</a>";
                }

                return data;
              }
            },
            {
              data: "graetzl_name"
            },
            {
              data: "created_at",
              render: function render(data, type) {
                if (type == "sort" || type == "type") {
                  return data;
                } else {
                  // Use Friendly Format for Output
                  return moment(data).format("lll");
                }
              }
            }
          ]
        });
      }; // Create DATATABLE MEETINGS

      var datatable_meetings = function datatable_meetings() {
        $("#datatable_meetings").DataTable({
          data: meetings,
          order: [[3, "desc"]],
          processing: true,
          paging: false,
          bDestroy: true,
          searching: false,
          columns: [
            {
              data: "id"
            },
            {
              data: "name",
              render: function render(data, type, row, meta) {
                if (type === "display") {
                  data =
                    '<a href="' +
                    row["meetings_path_admin"] +
                    '" target="_blank">' +
                    data +
                    "</a>";
                }

                return data;
              }
            },
            {
              data: "graetzl_name"
            },
            {
              data: "created_at",
              render: function render(data, type) {
                if (type == "sort" || type == "type") {
                  return data;
                } else {
                  // Use Friendly Format for Output
                  return moment(data).format("lll");
                }
              }
            }
          ]
        });
      }; // Create DATATABLE ROOMS

      var datatable_rooms = function datatable_rooms() {
        $("#datatable_rooms").DataTable({
          data: rooms,
          order: [[2, "desc"]],
          processing: true,
          paging: false,
          bDestroy: true,
          searching: false,
          columns: [
            {
              data: "type_friendly"
            },
            {
              data: "name",
              render: function render(data, type, row, meta) {
                if (type === "display") {
                  data =
                    '<a href="' +
                    row["room_path_admin"] +
                    '" target="_blank">' +
                    data +
                    "</a>";
                }

                return data;
              }
            },
            {
              data: "created_at",
              render: function render(data, type) {
                if (type == "sort" || type == "type") {
                  return data;
                } else {
                  // Use Friendly Format for Output
                  return moment(data).format("lll");
                }
              }
            }
          ]
        });
      }; // END Create Datatables (jQuery Plugin) //

      /*********************************
           Draw CHARTs
       *********************************/
      // Chart Graetzls

      var graetzlsChart = function graetzlsChart(type) {
        var topGraetzlCount = 13;
        var sumTopGraetzl = 0; // Reset

        var sumRemainingGraetzl = 0; // Reset

        var headline = "";
        var headlineTimePeriod = "";
        var zeroGraetzl = 0;
        var chartlabel, chartdata, sum;
        var color0 = "rgba(205, 137, 27, 0.9)";
        var color1 = "rgba(205, 137, 27, 0.6)";
        var color2 = "rgba(205, 137, 27, 0.4)";
        var color3 = "rgba(205, 137, 27, 0.2)";
        var color4 = "rgba(237, 129, 117, 1.0)";
        var color5 = "rgba(237, 129, 117, 0.7)";
        var color6 = "rgba(237, 129, 117, 0.5)";
        var color7 = "rgba(237, 129, 117, 0.2)";
        var color8 = "rgba(131, 199, 189, 1.0)";
        var color9 = "rgba(131, 199, 189, 0.7)";
        var color10 = "rgba(131, 199, 189, 0.5)";
        var color11 = "rgba(131, 199, 189, 0.3)";
        var color12 = "rgba(131, 199, 189, 0.1)";

        if (type == "total") {
          chartdata = graetzls_count.total.chartData;
          chartlabel = graetzls_count.total.chartLabel;
          sum = graetzls_count.total.sum;
        } else if (type == "actual") {
          chartdata = graetzls_count.actual.chartData;
          chartlabel = graetzls_count.actual.chartLabel;
          sum = graetzls_count.actual.sum;
        }

        for (i = 0; i < topGraetzlCount; i++) {
          sumTopGraetzl += chartdata[i]; // Count Sum of Users in Top Grätzl
        }

        for (i = topGraetzlCount; i < chartdata.length; i++) {
          sumRemainingGraetzl += chartdata[i]; // Count Sum of Users in remaining Grätzls
        }

        var findZeroGraetzl = function findZeroGraetzl(element) {
          return element == 0;
        };

        var resultIndex = chartdata.findIndex(findZeroGraetzl); // Get Index of first Element in Grätzl Array without User

        var sumGraetzl = chartdata.length; // Sum of all Grätzls

        if (resultIndex != -1) {
          zeroGraetzl = sumGraetzl - resultIndex; // Count of Grätzls without User
        }

        var activeGraetzls = sumGraetzl - zeroGraetzl;
        var remainingGraetzlCount = activeGraetzls - topGraetzlCount;
        /*
        console.log('Anzahl Top Grätzl :' + topGraetzlCount);
        console.log('Anzahl Grätz ohne User :' + zeroGraetzl);
        console.log('Anzahl Grätzl Array gesamt: ' + sumGraetzl);
        console.log('Anzahl Grätzln mit User: ' + activeGraetzls);
        console.log('Anzahl restlicher Grätzln mit User: ' + remainingGraetzlCount);
        console.log('Summer User in Top Grätzl: ' + sumTopGraetzl);
        console.log('Summe User im Zeitraum: ' + sum);
        console.log('Summe User in restlichen Grätzln: ' + sumRemainingGraetzl);
        console.log(chartdata);
        console.log(chartlabel);
        console.log(initDate);
        console.log(initUnit);
        */
        // Friendly Text for Headline

        if (initUnit == "days") {
          headlineTimePeriod = "in den letzten " + initPeriod + " Tagen";
        } else if (initUnit == "months") {
          actualMonth = moment(initDate);
          actualMonth = actualMonth.format("MMMM YYYY");
          headlineTimePeriod = "im " + actualMonth;
        } // Kürzen auf Top Grätzl

        chartdata.splice(topGraetzlCount);
        chartdata.push(sumRemainingGraetzl);
        chartlabel.splice(topGraetzlCount);
        chartlabel.push(
          "" +
            remainingGraetzlCount +
            " weitere Grätzl (" +
            sumRemainingGraetzl +
            ")"
        );

        if (type == "total") {
          headline = "Gesamt: " + sum + " User in " + graetzls.length + " Grätzln";
        } else if (type == "actual") {
          headline = sum + " neue User " + headlineTimePeriod;
        }

        var data = {
          datasets: [
            {
              data: chartdata,
              backgroundColor: [
                color0,
                color1,
                color2,
                color3,
                color4,
                color5,
                color6,
                color7,
                color8,
                color9,
                color10,
                color11,
                color12
              ]
            }
          ],
          labels: chartlabel
        };
        chartGraetzlTopArea = new Chart(graetzlchart, {
          type: "doughnut",
          data: data,
          options: {
            responsive: true,
            legend: {
              position: "right"
            },
            title: {
              display: true,
              text: headline,
              fontSize: 16,
              padding: 10,
              position: "top"
            },
            animation: {
              animateScale: true,
              animateRotate: true
            }
          }
        });
      }; // Chart Graetzls
      // Chart Mailings

      var mailingChart = function mailingChart(labeldata, sent, opens, clicks) {
        var color0 = "rgba(237, 129, 117, 0.5)";
        var color1 = "rgba(131, 199, 189, 0.5)";
        chartTopArea = new Chart(topchart, {
          type: "bar",
          data: {
            labels: ["Sent", "Opens", "Clicks"],
            datasets: [
              {
                label: labeldata[0],
                data: [sent[0], opens[0], clicks[0]],
                backgroundColor: color0,
                yAxisID: "mailing",
                borderWidth: 1
              },
              {
                label: labeldata[1],
                data: [sent[1], opens[1], clicks[1]],
                backgroundColor: color1,
                yAxisID: "mailing",
                borderWidth: 1
              }
            ]
          },
          // Chart Options
          options: {
            scales: {
              yAxes: [
                {
                  id: "mailing"
                }
              ]
            }
          }
        });
      }; // Chart Mailing

      /*********************************
         Create SINGLE USER View
       *********************************/

      var singleUser = function singleUser(user_id) {
        //$('#page_users').hide();
        $("div.page").hide();
        $("#page_singleuser").show();
        $("html, body").animate(
          {
            scrollTop: $("#report_nav").offset().top
          },
          100
        ); // Reset & Clear Mailing Output

        $("#u_mc_activity").html("");
        $('<em class="empty">Noch keine Mailings</em>').appendTo("#u_mc_activity"); // Reset & Clear Location Output

        $("#u_location").html("");
        $('<em class="empty">Noch keine Locations</em>').appendTo("#u_location"); // Reset & Clear Room Output

        $("#u_room").html("");
        $('<em class="empty">Noch keine Raumteiler</em>').appendTo("#u_room"); // Reset & Clear Meetings Output

        $("#u_meeting").html("");
        $('<em class="empty">Noch keine Treffen</em>').appendTo("#u_meeting"); // Reset & Clear Updates Output

        $("#u_update").html("");
        $('<em class="empty">Noch keine Updates</em>').appendTo("#u_update"); // Remove more Links

        $(".showmorelink").remove(); // Create new User for ID

        var user = new User(user_id); // Request User Infos

        Promise.resolve(user.getUser()).then(function(res) {
          $("#u_id").html("Id: " + user.id);
          $("#u_firstname").html(user.first_name);
          $("#u_lastname").html(user.last_name);
          $("#u_username").html(user.username);
          $("#u_email").html(user.email);
          $("#u_graetzl").html(user.graetzl_name);
          $("#u_created_at").html(moment(user.created_at).format("ll"));
          $("#u_last_login").html(
            user.last_login
              ? moment(user.last_login).format("ll")
              : "noch kein Login"
          );
          $("#u_admin").attr("href", user.user_path_admin);
          $("#u_role")
            .html(user.role)
            .removeClass("admin business")
            .addClass(user.role);
          $("#u_zip").html("");
          user.newsletter ? $("#u_newsletter").show() : $("#u_newsletter").hide();
          user.role ? $("#u_role").show() : $("#u_role").hide();

          for (i = 0; i < user.districts.length; i++) {
            $("<span>")
              .html(user.districts[i].zip)
              .appendTo("#u_zip");
          }

          if (user.avatar == null) {
            $("#u_avatar").attr("src", "/assets/img/400x400.png");
          } else {
            $("#u_avatar").attr("src", user.avatar);
          } // Request User Mailings when User Infos are loaded!

          Promise.resolve(user.getMailings()).then(function(res) {
            if (res != 404) {
              var activity = res.body.activity; //console.log(activity);

              for (i = 0; i < activity.length; i++) {
                $(
                  "<div>" +
                    '<span class="time">' +
                    moment(new Date(activity[i].timestamp)).format("ll") +
                    "</span>" +
                    '<span class="action"><ul class="tag-list ' +
                    activity[i].action +
                    '">' +
                    "<li>" +
                    activity[i].action +
                    "</li>" +
                    "</ul></span>" +
                    '<span class="name">' +
                    activity[i].title +
                    "</span></div>"
                ).appendTo("#u_mc_activity");
                $("#u_mc_activity .empty").hide();
              } //console.log(res.body.activity);
            }
          });
        }); // Request User Locations

        Promise.resolve(user.getLocations()).then(function(res) {
          for (i = 0; i < user.locations.length; i++) {
            $(
              '<div><a href="' +
                user.locations[i].location_path +
                '" target="_blank">' +
                user.locations[i].name +
                "</a></div>"
            ).appendTo("#u_location");
            $("#u_location .empty").hide();
          }

          if (user.locations.length >= 4) {
            $(
              '<a href="#" data-id="u_location" class="showmorelink">Weitere anzeigen ..</a>'
            )
              .on("click", function() {
                showmore("u_location");
              })
              .appendTo("#u_locations");
          } // After Locations are done, get Updates.

          requestLocationUpdates();
        }); // Request User Locations
        // Get Updates from User Locations

        var requestLocationUpdates = function requestLocationUpdates() {
          Promise.resolve(user.getLocationUpdates()).then(function(res) {
            //console.log(user.updates);
            for (u = 0; u < user.updates.length; u++) {
              $(
                '<div><a href="' +
                  user.updates[u].update_path_admin +
                  '" target="_blank">' +
                  user.updates[u].title +
                  "</a></div>"
              ).appendTo("#u_update");
              $("#u_update .empty").hide();
            }

            if (user.updates.length >= 4) {
              $(
                '<a href="#" data-id="u_update" class="showmorelink">Weitere anzeigen ..</a>'
              )
                .on("click", function() {
                  showmore("u_update");
                })
                .appendTo("#u_updates");
            }
          });
        }; // Request User Meetings

        Promise.resolve(user.getMeetings()).then(function(res) {
          for (i = 0; i < user.meetings.length; i++) {
            $(
              '<div><a href="' +
                user.meetings[i].meetings_path +
                '" target="_blank">' +
                user.meetings[i].name +
                "</a></div>"
            ).appendTo("#u_meeting");
            $("#u_meeting .empty").hide();
          }

          if (user.meetings.length >= 4) {
            $(
              '<a href="#" data-id="u_meeting" class="showmorelink">Weitere anzeigen ..</a>'
            )
              .on("click", function() {
                showmore("u_meeting");
              })
              .appendTo("#u_meetings");
          }
        });
        var r1 = Promise.resolve(user.getRooms("room_offers"));
        var r2 = Promise.resolve(user.getRooms("room_demands"));
        Promise.all([r1, r2]).then(function(res) {
          for (i = 0; i < user.rooms.length; i++) {
            $(
              '<div><a href="' +
                user.rooms[i].room_path_admin +
                '" target="_blank">' +
                user.rooms[i].name +
                "</a></div>"
            ).appendTo("#u_room");
            $("#u_room .empty").hide();
          }

          if (user.rooms.length >= 4) {
            $(
              '<a href="#" data-id="u_room" class="showmorelink">Weitere anzeigen ..</a>'
            )
              .on("click", function() {
                showmore("u_room");
              })
              .appendTo("#u_rooms");
          }
        });
      }; // Single User Page

      /*********************************
           EVENT -
          LISTENERS
       *********************************/

      $(document).ready(function() {
        // onChange Month Navigation Dropdown
        $("#months").change(function() {
          initDate = new Date(
            this.options[this.selectedIndex].getAttribute("data-day")
          );
          checkPeriod = this.options[this.selectedIndex].getAttribute(
            "data-period"
          ); //console.log(initPeriod);

          checkPeriod ? (initPeriod = checkPeriod) : (initPeriod = 0);
          initUnit = this.options[this.selectedIndex].getAttribute("data-unit");
          var actualPage = $("button[class*='-rosa']").attr("data-nav");

          if (actualPage == "page_graetzls") {
            // Inform PageLoader to Load new Users for Timeperiod
            page_loader(actualPage, true);
          } else {
            page_loader(actualPage);
          }
        }); // Page Navigation - Switch Pages on Button Click

        $("#report_nav button.pages").on("click", function() {
          var page = $(this).attr("data-nav");
          $("#report_nav button.-rosa")
            .removeClass("-rosa")
            .addClass("-mint");
          $(this)
            .addClass("-rosa")
            .removeClass("-mint");
          page_loader(page);
        }); // Nav
        // Back Button User Detail-Page

        $("#users_back").on("click", function() {
          page_loader("page_users");
        }); // Toggle Search Field

        $("#btn-search").on("click", function() {
          $("#page_search").slideToggle();
        }); // Toogle
        // Search Form Submit

        $(document).on("submit", "#search-form", function(event) {
          event.preventDefault();
          var searchParam = requestUserSearch($("#search-value").val());
          Promise.resolve(searchParam).then(function(res) {
            var actualPage = $("button[class*='-rosa']");
            var goalPage = $("button").filter('[data-nav="page_users"]');
            actualPage.removeClass("-rosa").addClass("-mint");
            goalPage.addClass("-rosa").removeClass("-mint");
            page_loader("page_users", "search");
          });
        }); // Search
        // Open Single User Page

        $(".datatable_users").on("click", "a.user", function(event) {
          event.preventDefault();
          singleUser($(this).data("id"));
        }); // Hover Data-Table Row

        $(".datatable_users").on("mouseover", "tr.odd, tr.even", function() {
          $(this)
            .find("svg")
            .addClass("over");
        });
        $(".datatable_users").on("mouseleave", "tr.odd, tr.even", function() {
          $(this)
            .find("svg")
            .removeClass("over");
        }); // Click on Sorting Grätzl Table

        $("#datatable_graetzls").on("click", "th", function(event) {
          event.preventDefault();
          var getSorting = this.getAttribute("data-user"); //console.log('sorting: ' + getSorting);

          if (getSorting == "actual") {
            resetTopChart();
            showSpinner();
            setGraetzlChartData("actual");
            graetzlsChart("actual");
            stopSpinner("page_graetzls");
          } else if (getSorting == "total") {
            resetTopChart();
            showSpinner();
            setGraetzlChartData("total");
            graetzlsChart("total");
            stopSpinner("page_graetzls");
          }
        });
      }); // END Event Listeners //
    }; // REPORT INIT



    return {
        init: init
    }

})();
