@REQ_HU-001 @HU001 @crud_marvel_heroes @marvel_heroes @Agente2 @E2
Feature: HU-001 Test de API de personajes de Marvel

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fvillanu'
    * def characterSchema =
    """
    {
      id: '#number',
      name: '#string',
      alterego: '#string',
      description: '#string',
      powers: '#[] #string',
    }
    """
    Given url baseUrl

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-HU-001-CA01-Obtener todos los personajes exitoso 200 - karate
    Given path 'api', 'characters'
    When method get
    Then status 200
    * print response
    And match each response == characterSchema

  @id:2 @obtenerUnPersonaje @solicitudExitosa200
  Scenario: T-API-HU-001-CA02-Obtener un personaje por ID exitoso 200 - karate
    Given path 'api', 'characters', '2'
    When method get
    Then status 200
    * print response
    And match response == characterSchema
    And response.id == 2

  @id:3 @obtenerPersonajeNoEncontrado @solicitudFallida404
  Scenario: T-API-HU-001-CA03-Error al obtener un personaje inexistente 404 - karate
    Given path 'api', 'characters', '999'
    When method get
    Then status 404
    * print response
    And response.error == 'Character not found'

  @id:4 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-HU-001-CA04-Crear un personaje exitoso 201 - karate
    Given path 'api', 'characters'
    * def body = read('classpath:data/marvel_characters/flash.json')
    * def randomNumber = java.lang.Math.floor(Math.random() * 1000)
    * body.name = 'Flash ' + randomNumber
    And request body
    When method post
    * print response
    Then status 201

  @id:5 @crearPersonajeNombreDuplicado @solicitudFallida400
  Scenario: T-API-HU-001-CA05-Error al crear un personaje con nombre duplicado 400 - karate
    Given path 'api', 'characters'
    * def body = read('classpath:data/marvel_characters/flash.json')
    And request body
    When method post
    Then status 400
    * print response
    And response.error == 'Character name already exists'

  @id:6 @crearPersonajeCamposFaltantes @solicitudFallida400
  Scenario: T-API-HU-001-CA06-Error al crear un personaje con campos faltantes 400 - karate
    Given path 'api', 'characters'
    * def body = read('classpath:data/marvel_characters/incomplete_flash.json')
    And request body
    When method post
    Then status 400
    * print response
    And response.alterego == 'Alterego is required'

  @id:7 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-HU-001-CA07-Actualizar un personaje existente exitoso 200 - karate
    Given path 'api', 'characters', '2'
    * def body = read('classpath:data/marvel_characters/updated_flash.json')
    And request body
    When method put
    Then status 200
    * print response
    And match response contains body

  @id:8 @actualizarPersonajeInexistente @solicitudFallida404
  Scenario: T-API-HU-001-CA08-Actualizar un personaje inexistente 404 - karate
    Given path 'api', 'characters', '999'
    * def body = read('classpath:data/marvel_characters/updated_flash.json')
    And request body
    When method put
    Then status 404
    * print response
    And response.error == 'Character not found'

  @id:9 @borrarPersonajeInexistente @solicitudFallida404
  Scenario: T-API-HU-001-CA09-Eliminar un personaje inexistente 404 - karate
    Given path 'api', 'characters', '999'
    When method delete
    Then status 404
    * print response
    And response.error == 'Character not found'

  @id:10 @borrarPersonajeExistente @solicitudExitosa204
  Scenario: T-API-HU-001-CA10-Eliminar un personaje existente exitoso 204 - karate
    Given path 'api', 'characters', 1
    When method delete
    Then status 204
    * print response
