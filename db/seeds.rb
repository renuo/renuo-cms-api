CredentialPair.create!(api_key: 'aValidApiKey', private_api_key: 'AdminONLY')
ContentBlock.create!(content_path: 'some/path/to/some/content',
                     content: 'this is the content of <strong>some/path/to/some/content</stong>',
                     api_key: 'aValidApiKey')
ContentBlock.create!(content_path: 'content/blub', content: '<strong>yay</strong> it works!',
                     api_key: 'aValidApiKey')
ContentBlock.create!(content_path: 'even-more-content', content: '<strong>yay</strong> it works!',
                     api_key: 'aValidApiKey')

CredentialPair.create!(api_key: 'anotherPublicKey', private_api_key: 'SuperAdminOnly')
ContentBlock.create!(content_path: 'content/blub', content: 'It also works :D',
                     api_key: 'anotherPublicKey')
