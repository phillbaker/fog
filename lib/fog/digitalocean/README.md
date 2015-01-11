# Fog DigitalOcean

## Examples

Getting started example: https://github.com/fog/fog/blob/master/lib/fog/digitalocean/examples/getting_started.md

## Testing

Testing can be done against mocks (hard coded API response values) or against the real live API.

### Mocks

Run:

```
FOG_MOCK=true bundle exec shindont tests/digitalocean
```

### Real API

Ensure that you have a `test/.fog` or `~/.fog` file with the following mininmum keys defined:

```
default:
  public_key_path: ~/.ssh/fog_rsa.pub
  private_key_path: ~/.ssh/fog_rsa

digitalocean:
  digitalocean_oauth_token: "foo"
```

Run:

```
FOG_CREDENTIAL=digitalocean FOG_MOCK=true bundle exec shindont tests/digitalocean
```
