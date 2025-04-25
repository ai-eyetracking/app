import Greeting from './components/Greeting.vue'

const components = {
  'Greeting': Greeting,
}

export function getComponent(name) {
  return components[name]
}