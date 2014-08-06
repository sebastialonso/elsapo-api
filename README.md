#Documentación para nueva versión de El Sapo

##Motor base de datos: Postgresql
Se migrará la aplicación a una base de datos Postgresql debido a que PSQL cuenta con la extensión postgis, que permite manejar tipos de datos creados eespecialmente para el manejo de GIS (Geographic Information Systems). Entre los tipos de data útiles se encuentran puntos, línea y polígonos.

Una vez creada la aplicación con el flag `--database=postgresql`, debe instalarse la gema 'activerecord-postgis-adapter'. Esta gema inserta un nuevo adaptador para base de datos, permitiendo que Rails entienda a Postgis como un nuevo tipo de base de datos.
~~~
#Gemfile
gem 'activerecord-postgis-adapter'
~~~

Debe crear también la extension postgis en la base de datos:
~~~
$ rails dbconsole
Password: ...

> CREATE EXTENSION postgis;
~~~

Con esto, la nueva aplicación queda lista para almanecar y entender tipos de datos de postgis.

##Database yml
Con el cambio de adaptador, el archivo `database.yml` quedará como sigue:
~~~
default: &default
  adapter: postgis
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5

development:
  <<: *default
  database: sapo_test_development

test:
  <<: *default
  database: sapo_test_test

production:
  <<: *default
  database: sapo_test_production
  username: sapo_test
  password: <%= ENV['SAPO_TEST_DATABASE_PASSWORD'] %>
~~~


##Modelos
Algunos modelos tendrán que ser replanteados desde el punto de vista de tipo de atributos.

###Cambio transversal
Para todos los modelos que contengan `:latitude` y `:longitude`, estos dos campos dejarán de existir. En su reemplazo, el campo `:position`, tipo de data `Point(LONGITUDE, LATITUDE)` contendrá la misma información en formato postgis.

###Paraderos (Stops)
La migración que da origen a la tabla queda como sigue:
~~~ruby
class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.point :position, geographic: true
      t.boolean :direction
      t.decimal :radius
      t.string :name
      
      t.timestamps
    end
  end
end
~~~

Como se definió anteriormente, `:position` ahora es de tipo `POINT`. Se pasa la opción `geographic` de manera que las distancias calculadas desde y hacia ese punto se calculen sobre una Tierra tridimensional y no plana.
