function initialize() {
    var myLatlng = new google.maps.LatLng(44.49658, -73.11217);
    var mapOptions = {
	zoom: 14,
	center: myLatlng,
	mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById('map-canvas'),
			      mapOptions);
    
    var marker = new google.maps.Marker({
	position: myLatlng,
	map: map,
	title: 'Vermont Center for Occupational Rehabilitation'
    });   
}

google.maps.event.addDomListener(window, 'load', initialize);

var metrics = [
    [ '#inputName',  'presence', 'Cannot be empty' ],
    [ '#inputEmail', 'presence', 'Cannot be empty' ],
    [ '#inputSubject', 'presence', 'Cannot be empty' ],
    [ '#inputMessage', 'presence', 'Cannot be empty' ],
];
$( "#contact" ).nod( metrics );