/**
 * Creates a new identity quat
 *
 * @returns {quat} a new quaternion
 */
function quat_create() 
{
	return [0,0,0,1];
}

/**
 * Set a quat to the identity quaternion
 *
 * @param {quat} out the receiving quaternion
 * @returns {quat} out
 */
function quat_identity(out)
{
	out[0] = 0;
	out[1] = 0;
	out[2] = 0;
	out[3] = 1;
	return out;
}

/**
 * Sets a quat from the given angle and rotation axis,
 * then returns it.
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyVec3} axis the axis around which to rotate
 * @param {Number} rad the angle in radians
 * @returns {quat} out
 **/
function quat_setAxisAngle(out, axis, rad){
	rad = rad * 0.5;
	var s = sin(rad);
	out[0] = s * axis[0];
	out[1] = s * axis[1];
	out[2] = s * axis[2];
	out[3] = cos(rad)
	return out;
}

/**
 * Gets the rotation axis and angle for a given
 *  quaternion. If a quaternion is created with
 *  setAxisAngle, this method will return the same
 *  values as providied in the original parameter list
 *  OR functionally equivalent values.
 * Example: The quaternion formed by axis [0, 0, 1] and
 *  angle -90 is the same as the quaternion formed by
 *  [0, 0, 1] and 270. This method favors the latter.
 * @param  {vec3} out_axis  Vector receiving the axis of rotation
 * @param  {ReadonlyQuat} q     Quaternion to be decomposed
 * @return {Number}     Angle, in radians, of the rotation
 */
function quat_getAxisAngle(out_axis, q) {
  var rad = arccos(q[3]) * 2.0;
  var s = sin(rad / 2.0);
  if (s > GMLGL_EPSILON) {
    out_axis[0] = q[0] / s;
    out_axis[1] = q[1] / s;
    out_axis[2] = q[2] / s;
  } else {
    // If s is zero, return any axis (no rotation - axis does not matter)
    out_axis[0] = 1;
    out_axis[1] = 0;
    out_axis[2] = 0;
  }
  return rad;
}

/**
 * Gets dot product between two quaternions
 *
 * @param  {ReadonlyQuat} a     LHS quaternion
 * @param  {ReadonlyQuat} b     RHS quaternion
 * @return {Number}     Dot product
 */

/**
 * Gets the angular distance between two unit quaternions
 *
 * @param  {ReadonlyQuat} a     Origin unit quaternion
 * @param  {ReadonlyQuat} b     Destination unit quaternion
 * @return {Number}     Angle, in radians, between the two quaternions
 */
function quat_getAngle(a, b) {
  var dotproduct = quat_dot(a, b);
  return arccos(2 * dotproduct * dotproduct - 1);
}
/**
 * Multiplies two quat's
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a the first operand
 * @param {ReadonlyQuat} b the second operand
 * @returns {quat} out
 */
function quat_multiply(out, a, b) {
  var ax = a[0],
  ay = a[1],
  az = a[2],
  aw = a[3],
  bx = b[0],
  by = b[1],
  bz = b[2],
  bw = b[3];
  out[0] = ax * bw + aw * bx + ay * bz - az * by;
  out[1] = ay * bw + aw * by + az * bx - ax * bz;
  out[2] = az * bw + aw * bz + ax * by - ay * bx;
  out[3] = aw * bw - ax * bx - ay * by - az * bz;
  return out;
}
/**
 * Rotates a quaternion by the given angle about the X axis
 *
 * @param {quat} out quat receiving operation result
 * @param {ReadonlyQuat} a quat to rotate
 * @param {number} rad angle (in radians) to rotate
 * @returns {quat} out
 */
function quat_rotateX(out, a, rad) {
  rad *= 0.5;
  var ax = a[0],
  ay = a[1],
  az = a[2],
  aw = a[3];
  var bx = sin(rad),
  bw = cos(rad);
  out[0] = ax * bw + aw * bx;
  out[1] = ay * bw + az * bx;
  out[2] = az * bw - ay * bx;
  out[3] = aw * bw - ax * bx;
  return out;
}

/**
 * Rotates a quaternion by the given angle about the Y axis
 *
 * @param {quat} out quat receiving operation result
 * @param {ReadonlyQuat} a quat to rotate
 * @param {number} rad angle (in radians) to rotate
 * @returns {quat} out
 */
function quat_rotateY(out, a, rad) {
  rad *= 0.5;
  var ax = a[0],
  ay = a[1],
  az = a[2],
  aw = a[3];
  var by = sin(rad),
  bw = cos(rad);
  out[0] = ax * bw - az * by;
  out[1] = ay * bw + aw * by;
  out[2] = az * bw + ax * by;
  out[3] = aw * bw - ay * by;
  return out;
}
/**
 * Rotates a quaternion by the given angle about the Z axis
 *
 * @param {quat} out quat receiving operation result
 * @param {ReadonlyQuat} a quat to rotate
 * @param {number} rad angle (in radians) to rotate
 * @returns {quat} out
 */
function quat_rotateZ(out, a, rad) {
  rad *= 0.5;
  var ax = a[0],
  ay = a[1],
  az = a[2],
  aw = a[3];
  var bz = sin(rad),
  bw = cos(rad);
  out[0] = ax * bw + ay * bz;
  out[1] = ay * bw - ax * bz;
  out[2] = az * bw + aw * bz;
  out[3] = aw * bw - az * bz;
  return out;
}
/**
 * Calculates the W component of a quat from the X, Y, and Z components.
 * Assumes that quaternion is 1 unit in length.
 * Any existing W component will be ignored.
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a quat to calculate W component of
 * @returns {quat} out
 */
function quat_calculateW(out, a) {
  var _x = a[0],
  _y = a[1],
  _z = a[2];
  out[0] = _x;
  out[1] = _y;
  out[2] = _z;
  out[3] = sqrt(abs(1.0 - _x * _x - _y * _y - _z * _z));
  return out;
}
/**
 * Calculate the exponential of a unit quaternion.
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a quat to calculate the exponential of
 * @returns {quat} out
 */
function quat_exp(out, a) {
  var _x = a[0],
  _y = a[1],
  _z = a[2],
  _w = a[3];
  var r = sqrt(_x * _x + _y * _y + _z * _z);
  var et = exp(_w);
  var s = r > 0 ? (et * sin(r)) / r : 0;
  out[0] = _x * s;
  out[1] = _y * s;
  out[2] = _z * s;
  out[3] = et * cos(r);
  return out;
}

/**
 * Calculate the natural logarithm of a unit quaternion.
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a quat to calculate the exponential of
 * @returns {quat} out
 */
function quat_ln(out, a) {
  var _x = a[0],
  _y = a[1],
  _z = a[2],
  _w = a[3];
  var r = sqrt(_x * _x + _y * _y + _z * _z);
  var t = r > 0 ? arctan2(r, _w) / r : 0;
  out[0] = _x * t;
  out[1] = _y * t;
  out[2] = _z * t;
  out[3] = 0.5 * ln(_x * _x + _y * _y + _z * _z + _w * _w);
  return out;
}

/**
 * Calculate the scalar power of a unit quaternion.
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a quat to calculate the exponential of
 * @param {Number} b amount to scale the quaternion by
 * @returns {quat} out
 */
function quat_pow(out, a, b) {
  ln(out, a);
  quat_scale(out, out, b);
  exp(out, out);
  return out;
}
/**
 * Performs a spherical linear interpolation between two quat
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a the first operand
 * @param {ReadonlyQuat} b the second operand
 * @param {Number} t interpolation amount, in the range [0-1], between the two inputs
 * @returns {quat} out
 */
function quat_slerp(out, a, b, t) {
  // benchmarks:
  //    http://jsperf.com/quaternion-slerp-implementations
  var ax = a[0],
  ay = a[1],
  az = a[2],
  aw = a[3];
  var bx = b[0],
  by = b[1],
  bz = b[2],
  bw = b[3];
  var omega, cosom, sinom, scale0, scale1;
  // calc cosine
  cosom = ax * bx + ay * by + az * bz + aw * bw;
  // adjust signs (if necessary)
  if (cosom < 0.0) {
    cosom = -cosom;
    bx = -bx;
    by = -by;
    bz = -bz;
    bw = -bw;
  }
  // calculate coefficients
  if (1.0 - cosom > GMLGL_EPSILON) {
    // standard case (slerp)
    omega = arccos(cosom);
    sinom = sin(omega);
    scale0 = sin((1.0 - t) * omega) / sinom;
    scale1 = sin(t * omega) / sinom;
  } else {
    // "from" and "to" quaternions are very close
    //  ... so we can do a linear interpolation
    scale0 = 1.0 - t;
    scale1 = t;
  }
  // calculate final values
  out[0] = scale0 * ax + scale1 * bx;
  out[1] = scale0 * ay + scale1 * by;
  out[2] = scale0 * az + scale1 * bz;
  out[3] = scale0 * aw + scale1 * bw;
  return out;
}
/**
 * Generates a random unit quaternion
 *
 * @param {quat} out the receiving quaternion
 * @returns {quat} out
 */
function quat_random(out) {
  // Implementation of http://planning.cs.uiuc.edu/node198.html
  var u1 = random(1),
  u2 = random(1),
  u3 = random(1);
  var sqrt1MinusU1 = sqrt(1 - u1);
  var sqrtU1 = sqrt(u1);
  out[0] = sqrt1MinusU1 * sin(2.0 * pi * u2);
  out[1] = sqrt1MinusU1 * cos(2.0 * pi * u2);
  out[2] = sqrtU1 * sin(2.0 * pi * u3);
  out[3] = sqrtU1 * cos(2.0 * pi * u3);
  return out;
}
/**
 * Calculates the inverse of a quat
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a quat to calculate inverse of
 * @returns {quat} out
 */
function quat_invert(out, a) {
  var a0 = a[0],
  a1 = a[1],
  a2 = a[2],
  a3 = a[3];
  var dot = a0 * a0 + a1 * a1 + a2 * a2 + a3 * a3;
  var invDot = dot ? 1.0 / dot : 0;
  out[0] = -a0 * invDot;
  out[1] = -a1 * invDot;
  out[2] = -a2 * invDot;
  out[3] = a3 * invDot;
  return out;
}

/**
 * Calculates the conjugate of a quat
 * If the quaternion is normalized, this function is faster than quat.inverse and produces the same result.
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a quat to calculate conjugate of
 * @returns {quat} out
 */
function quat_conjugate(out, a) {
  out[0] = -a[0];
  out[1] = -a[1];
  out[2] = -a[2];
  out[3] = a[3];
  return out;
}

/**
 * Creates a quaternion from the given 3x3 rotation matrix.
 *
 * NOTE: The resultant quaternion is not normalized, so you should be sure
 * to renormalize the quaternion yourself where necessary.
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyMat3} m rotation matrix
 * @returns {quat} out
 * @function
 */
function quat_fromMat3(out, m) {
  // Algorithm in Ken Shoemake's article in 1987 SIGGRAPH course notes
  // article "Quaternion Calculus and Fast Animation".
  var fTrace = m[0] + m[4] + m[8];
  var fRoot;
  if (fTrace > 0.0) {
    // |w| > 1/2, may as well choose w > 1/2
    fRoot = sqrt(fTrace + 1.0); // 2w
    out[3] = 0.5 * fRoot;
    fRoot = 0.5 / fRoot; // 1/(4w)
    out[0] = (m[5] - m[7]) * fRoot;
    out[1] = (m[6] - m[2]) * fRoot;
    out[2] = (m[1] - m[3]) * fRoot;
  } else {
    // |w| <= 1/2
    var i = 0;
    if (m[4] > m[0]) i = 1;
    if (m[8] > m[i * 3 + i]) i = 2;
    var j = (i + 1) % 3;
    var k = (i + 2) % 3;
    fRoot = sqrt(m[i * 3 + i] - m[j * 3 + j] - m[k * 3 + k] + 1.0);
    out[i] = 0.5 * fRoot;
    fRoot = 0.5 / fRoot;
    out[3] = (m[j * 3 + k] - m[k * 3 + j]) * fRoot;
    out[j] = (m[j * 3 + i] + m[i * 3 + j]) * fRoot;
    out[k] = (m[k * 3 + i] + m[i * 3 + k]) * fRoot;
  }
  return out;
}
/**
 * Creates a quaternion from the given euler angle x, y, z.
 *
 * @param {quat} out the receiving quaternion
 * @param {x} Angle to rotate around X axis in degrees.
 * @param {y} Angle to rotate around Y axis in degrees.
 * @param {z} Angle to rotate around Z axis in degrees.
 * @returns {quat} out
 * @function
 */
function quat_fromEuler(out, _x, _y, _z) {
  var halfToRad = (0.5 * pi) / 180.0;
  var _x = _x * halfToRad,
  _y = _y * halfToRad,
  _z = _z * halfToRad;
  var sx = sin(_x),
  cx = cos(_x),
  sy = sin(_y),
  cy = cos(_y),
  sz = sin(_z),
  cz = cos(_z);
  out[0] = sx * cy * cz - cx * sy * sz;
  out[1] = cx * sy * cz + sx * cy * sz;
  out[2] = cx * cy * sz - sx * sy * cz;
  out[3] = cx * cy * cz + sx * sy * sz;
  return out;
}
/**
 * Returns a string representation of a quaternion
 *
 * @param {ReadonlyQuat} a vector to represent as a string
 * @returns {String} string representation of the vector
 */
function quat_str(a) {
  return "quat(" + string(a[0]) + ", " + string(a[1])+ ", " + string(a[2]) + ", " + string(a[3]) + ")";
}
/**
 * Creates a new quat initialized with values from an existing quaternion
 *
 * @param {ReadonlyQuat} a quaternion to clone
 * @returns {quat} a new quaternion
 * @function
 */
function quat_clone(a){
	return vec4_clone(a)
}
/**
 * Creates a new quat initialized with the given values
 *
 * @param {Number} x X component
 * @param {Number} y Y component
 * @param {Number} z Z component
 * @param {Number} w W component
 * @returns {quat} a new quaternion
 * @function
 */
 function quat_fromValues(_x,_y,_z,_w){
	return vec4_fromValues(_x,_y,_z,_w)	 
 }
/**
 * Copy the values from one quat to another
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a the source quaternion
 * @returns {quat} out
 * @function
 */
 function quat_copy(out, a){
	return vec4_copy(out, a)	 
 }
/**
 * Set the components of a quat to the given values
 *
 * @param {quat} out the receiving quaternion
 * @param {Number} x X component
 * @param {Number} y Y component
 * @param {Number} z Z component
 * @param {Number} w W component
 * @returns {quat} out
 * @function
 */
function quat_set(out, _x, _y, _z, _w){
	return vec4_set(out, _x, _y, _z, _w)	
}
/**
 * Adds two quat's
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a the first operand
 * @param {ReadonlyQuat} b the second operand
 * @returns {quat} out
 * @function
 */

function quat_add(out, a, b){
	return vec4_add(out, a, b)
}

/**
 * Scales a quat by a scalar number
 *
 * @param {quat} out the receiving vector
 * @param {ReadonlyQuat} a the vector to scale
 * @param {Number} b amount to scale the vector by
 * @returns {quat} out
 * @function
 */
function quat_scale(out, a, b) {
	return vec4_scale(out, a, b)
}
/**
 * Calculates the dot product of two quat's
 *
 * @param {ReadonlyQuat} a the first operand
 * @param {ReadonlyQuat} b the second operand
 * @returns {Number} dot product of a and b
 * @function
 */
function quat_dot(a,b){
	return vec4_dot(a,b)
}
/**
 * Performs a linear interpolation between two quat's
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a the first operand
 * @param {ReadonlyQuat} b the second operand
 * @param {Number} t interpolation amount, in the range [0-1], between the two inputs
 * @returns {quat} out
 * @function
 */
 function quat_lerp(out, a, b, t){
	 return vec4_lerp(out, a, b, t)
 }
/**
 * Calculates the length of a quat
 *
 * @param {ReadonlyQuat} a vector to calculate length of
 * @returns {Number} length of a
 */
function quat_length(a){
	return vec4_length(a)
}
/**
 * Calculates the squared length of a quat
 *
 * @param {ReadonlyQuat} a vector to calculate squared length of
 * @returns {Number} squared length of a
 * @function
 */
function quat_squaredLength(a){
	return vec4_squaredLength(a)
}
/**
 * Normalize a quat
 *
 * @param {quat} out the receiving quaternion
 * @param {ReadonlyQuat} a quaternion to normalize
 * @returns {quat} out
 * @function
 */
function quat_normalize(out, a){
	return vec4_normalize(out, a)
}
/**
 * Returns whether or not the quaternions have exactly the same elements in the same position (when compared with ===)
 *
 * @param {ReadonlyQuat} a The first quaternion.
 * @param {ReadonlyQuat} b The second quaternion.
 * @returns {Boolean} True if the vectors are equal, false otherwise.
 */
function quat_exactEquals(a,b){
	return vec4_exactEquals(a,b)
}
/**
 * Returns whether or not the quaternions have approximately the same elements in the same position.
 *
 * @param {ReadonlyQuat} a The first vector.
 * @param {ReadonlyQuat} b The second vector.
 * @returns {Boolean} True if the vectors are equal, false otherwise.
 */
function quat_equals(a,b){
	return vec4_equals(a,b)
}



// Unfinished, non critical porting.

///**
// * Sets a quaternion to represent the shortest rotation from one
// * vector to another.
// *
// * Both vectors are assumed to be unit length.
// *
// * @param {quat} out the receiving quaternion.
// * @param {ReadonlyVec3} a the initial vector
// * @param {ReadonlyVec3} b the destination vector
// * @returns {quat} out
// */
//function quat_rotationTo(out, a, b) {
//  tmpvec3 = vec3.create();
//  xUnitVec3 = vec3.fromValues(1, 0, 0);
//  yUnitVec3 = vec3.fromValues(0, 1, 0);
//  return function(out, a, b) {
//    dot = vec3.dot(a, b);
//    if (dot < -0.999999) {
//      vec3.cross(tmpvec3, xUnitVec3, a);
//      if (vec3.len(tmpvec3) < 0.000001) vec3.cross(tmpvec3, yUnitVec3, a);
//      vec3.normalize(tmpvec3, tmpvec3);
//      setAxisAngle(out, tmpvec3, Math.PI);
//      return out;
//    } else if (dot > 0.999999) {
//      out[0] = 0;
//      out[1] = 0;
//      out[2] = 0;
//      out[3] = 1;
//      return out;
//    } else {
//      vec3.cross(tmpvec3, a, b);
//      out[0] = tmpvec3[0];
//      out[1] = tmpvec3[1];
//      out[2] = tmpvec3[2];
//      out[3] = 1 + dot;
//      return normalize(out, out);
//    }
//  };
//})();
///**
// * Performs a spherical linear interpolation with two control points
// *
// * @param {quat} out the receiving quaternion
// * @param {ReadonlyQuat} a the first operand
// * @param {ReadonlyQuat} b the second operand
// * @param {ReadonlyQuat} c the third operand
// * @param {ReadonlyQuat} d the fourth operand
// * @param {Number} t interpolation amount, in the range [0-1], between the two inputs
// * @returns {quat} out
// */
//const sqlerp = (function() {
//  temp1 = create();
//  temp2 = create();
//  return function(out, a, b, c, d, t) {
//    slerp(temp1, a, d, t);
//    slerp(temp2, b, c, t);
//    slerp(out, temp1, temp2, 2 * t * (1 - t));
//    return out;
//  };
//})();
///**
// * Sets the specified quaternion with values corresponding to the given
// * axes. Each axis is a vec3 and is expected to be unit length and
// * perpendicular to all other specified axes.
// *
// * @param {ReadonlyVec3} view  the vector representing the viewing direction
// * @param {ReadonlyVec3} right the vector representing the local "right" direction
// * @param {ReadonlyVec3} up    the vector representing the local "up" direction
// * @returns {quat} out
// */
//const setAxes = (function() {
//  matr = mat3.create();
//  return function(out, view, right, up) {
//    matr[0] = right[0];
//    matr[3] = right[1];
//    matr[6] = right[2];
//    matr[1] = up[0];
//    matr[4] = up[1];
//    matr[7] = up[2];
//    matr[2] = -view[0];
//    matr[5] = -view[1];
//    matr[8] = -view[2];
//    return normalize(out, fromMat3(out, matr));
//  };
//})();

