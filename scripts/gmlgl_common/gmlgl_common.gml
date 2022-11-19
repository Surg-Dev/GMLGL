#macro GMLGL_EPSILON 0.000001

function gmlgl_hypot(){
	var sum = 0
	for (var i = 0; i < argument_count; i++){
		sum += argument[i]*argument[i];
	}
	return sqrt(sum);
}
	