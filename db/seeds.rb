CredentialPair.create!(api_key: 'aValidApiKey', private_api_key: 'AdminONLY', project_name: 'some-project')
ContentBlock.create!(api_key: 'aValidApiKey', content_path: 'some/path/to/some/content', content: 'this is the content of <strong>some/path/to/some/content</stong>')
ContentBlock.create!(api_key: 'aValidApiKey', content_path: 'content/blub', content: '<strong>yay</strong> it works!',)
ContentBlock.create!(api_key: 'aValidApiKey', content_path: 'even-more-content', content: '<strong>yay</strong> it works!',)

CredentialPair.create!(api_key: 'anotherPublicKey', private_api_key: 'SuperAdminOnly', project_name: 'some-other-project')
ContentBlock.create!(api_key: 'anotherPublicKey', content_path: 'content/blub', content: 'It also works :D')
