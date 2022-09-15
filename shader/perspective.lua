local pshader = [[
    uniform number DARK = 1;
    varying vec3 light_attenuation;
    vec4 effect(vec4 colour, Image tex, vec2 tex_coords, vec2 screen_coords) {
        vec4 tex_colour = Texel(tex, tex_coords);
        vec4 atten4 = vec4(light_attenuation.xyz,1);
        return tex_colour * colour * vec4(DARK,DARK,DARK,1) * atten4;
    }
]]

local vshader = [[
    struct PointLight {
        vec3 pos;
        vec3 attenuation;
        number dist;
    };

    uniform number PI = 3.141592654;
    uniform number FOV_DEGREES = 80;

    uniform mat4 mat_model;
    uniform mat4 mat_view;

    uniform vec3 light_pos_in;
    uniform vec3 light_attenuation_in;
    uniform number light_dist_in;
    varying vec3 light_attenuation;

    mat4 perspective(number theta, number rho, number z0, number z1) {
        mat4 ret;
        ret[0] = vec4(1/(rho*tan(theta/2)), 0, 0, 0);
        ret[1] = vec4(0, 1/tan(theta/2), 0, 0);
        ret[2] = vec4(0, 0, (z0+z1)/(z0-z1), (2*z0*z1)/(z0-z1));
        ret[3] = vec4(0, 0, -1, 0);

        return transpose(ret);
    }

    mat4 translate(vec3 ds) {
        mat4 ret;
        ret[0] = vec4(1, 0, 0, ds.x);
        ret[1] = vec4(0, 1, 0, ds.y);
        ret[2] = vec4(0, 0, 0, ds.z);
        ret[3] = vec4(0, 0, 0, 1);
        
        return transpose(ret);
    }

    mat4 scale(vec3 sf) {
        mat4 ret;
        ret[0] = vec4(sf.x, 0, 0, 0);
        ret[1] = vec4(0, sf.y, 0, 0);
        ret[2] = vec4(0, 0, sf.z, 0);
        ret[3] = vec4(0, 0, 0, 1);

        return ret;
    }

    mat4 rotateXY(number theta) {
        mat4 ret;
        ret[0] = vec4(cos(theta), -sin(theta), 0, 0);
        ret[1] = vec4(sin(theta), cos(theta), 0, 0);
        ret[2] = vec4(0, 0, 1, 0);
        ret[3] = vec4(0, 0, 0, 1);

        return transpose(ret);
    }

    mat4 rotateXZ(number theta) {
        mat4 ret;
        ret[0] = vec4(cos(theta), 0, sin(theta), 0);
        ret[1] = vec4(0, 1, 0, 0);
        ret[2] = vec4(-sin(theta), 0, cos(theta), 0);
        ret[3] = vec4(0, 0, 0, 1);

        return transpose(ret);
    }

    mat4 rotateYZ(number theta) {
        mat4 ret;
        ret[0] = vec4(1, 0, 0, 0);
        ret[1] = vec4(0, cos(theta), -sin(theta), 0);
        ret[2] = vec4(0, sin(theta), cos(theta), 0);
        ret[3] = vec4(0, 0, 0, 1);

        return transpose(ret);
    }

    number interpolate(number min, number max, number x) {
        if(x < 0) return min;
        if(x > 1) return max;

        x = x * x * (3 - 2 * x);
        return (max-min)*x + min;
    }

    number dist(vec3 u, vec3 v) {
        number dx = u.x - v.x;
        number dy = u.y - v.y;
        number dz = u.z - v.z;
        return sqrt(dx*dx + dy*dy + dz*dz);
    }

    vec4 position(mat4 _, vec4 vertex_position) {
        vec4 model_vertex = mat_model * vertex_position;
        vec4 transformed = perspective(FOV_DEGREES*PI/180, 4/3, 0.1, 100) * mat_view * model_vertex;

        number d = dist(model_vertex.xyz, light_pos_in);
        d /= light_dist_in;
        d = clamp(1 - d, 0, 1);
        number light_strength = mix(0, light_dist_in, d) / light_dist_in;
        light_attenuation = light_attenuation_in * vec3(light_strength, light_strength, light_strength);
        
        return transformed;
    }
]]

return love.graphics.newShader(pshader, vshader)
