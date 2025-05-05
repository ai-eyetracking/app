import Greeting from './components/Greeting.vue'

const components = {
  'Greeting': Greeting,
}

export function getComponent(name) {
  console.log!("mounting", name)
  return components[name]
}