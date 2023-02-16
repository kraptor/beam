import math

import real
import colors
import vectors
import points
import lights

import entities
import materials

import patterns/patterns_impl


func lighting*(material: PhongMaterial, entity: Entity, light: PointLight, point: Point, eyev, normalv: Vector, in_shadow = false): Color =
    let
        # color depends inf the material has a pattern applied, in
        # that case, the color is defined by the pattern instead of
        # the material color
        color = if material.pattern != nil:
                    material.pattern.pattern_at_entity(entity, point)
                else:
                    material.color

        # combine the surface color with the light's color/intensity
        effective_color = color * light.intensity

        # compute the ambient contribution
        ambient = effective_color * material.ambient

    if in_shadow:
        # if a point is in shadow, only ambient contributes to final color
        return ambient

    let
        # find the direction to the light source
        lightv = (light.position - point).normalize

        # light_dot_normal represents the cosine of the angle between the
        # light vector and the normal vector. A negative number means the
        # light is on the other side of the surface.
        light_dot_normal = lightv.dot(normalv)
        
    var
        diffuse = Color.BLACK
        specular = Color.BLACK
        reflectv: Vector
        reflect_dot_eye: Real
        factor: Real # specular contribution
    
    if light_dot_normal >= 0:
        # compute the diffuse contribution
        diffuse = effective_color * material.diffuse * light_dot_normal
        
        # reflect_dot_eye represents the cosine of the angle between the
        # reflection vector and the eye vector. A negative number means the
        # light reflects away from the eye.
        reflectv = (-lightv).reflect(normalv)
        reflect_dot_eye = reflectv.dot(eyev)

        if reflect_dot_eye <= 0:
            specular = Color.BLACK
        else:
            # compute the specular contribution
            factor = pow(reflect_dot_eye, material.shininess)
            specular = light.intensity * material.specular * factor

    ambient + diffuse + specular