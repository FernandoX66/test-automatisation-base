@REQ_HU-001 @marvelHeroes
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

  @id:1 @getCharacters
  Scenario: T-API-HU-001-CA01-Obtener todos los personajes
    Given path 'api', 'characters'
    When method get
    Then status 200
    * print response
    And match each response == characterSchema

  @id:2 @getOneCharacter
  Scenario: Obtener un personaje por ID
    Given path 'api', 'characters', '2'
    When method get
    Then status 200
    * print response
    And match response == characterSchema

  @id:3 @getOneCharacterNotFound
  Scenario: Error al obtener un personaje inexistente
    Given path 'api', 'characters', '999'
    When method get
    Then status 404
    * print response
    And response.error == 'Character not found'

  @id:4 @createCharacter
  Scenario: Crear un personaje
    Given path 'api', 'characters'
    * def body = read('classpath:data/marvel_characters/flash.json')
    And request body
    When method post
    * print response
    Then status 201

  @id:5 @createCharacterDuplicateName
  Scenario: Error al crear un personaje con nombre duplicado
    Given path 'api', 'characters'
    * def body = read('classpath:data/marvel_characters/flash.json')
    And request body
    When method post
    Then status 400
    * print response
    And response.error == 'Character name already exists'

  @id:6 @createCharacterMissingFields
  Scenario: Error al crear un personaje con campos faltantes
    Given path 'api', 'characters'
    * def body = read('classpath:data/marvel_characters/incomplete_flash.json')
    And request body
    When method post
    Then status 400
    * print response
    And response.alterego == 'Alterego is required'

  @id:7 @updateCharacter
  Scenario: Actualizar un personaje existente
    Given path 'api', 'characters', '1'
    * def body = read('classpath:data/marvel_characters/updated_flash.json')
    And request body
    When method put
    Then status 200
    * print response
    And match response contains body

  @id:8 @updateNotExistingCharacter
  Scenario: Actualizar un personaje inexistente
    Given path 'api', 'characters', '999'
    * def body = read('classpath:data/marvel_characters/updated_flash.json')
    And request body
    When method put
    Then status 404
    * print response
    And response.error == 'Character not found'

  @id:9 @deleteCharacter
  Scenario: Eliminar un personaje existente
    Given path 'api', 'characters', '1'
    When method delete
    Then status 204
    * print response

  @id:10 @deleteNotExistingCharacter
  Scenario: Eliminar un personaje inexistente
    Given path 'api', 'characters', '999'
    When method delete
    Then status 404
    * print response
    And response.error == 'Character not found'