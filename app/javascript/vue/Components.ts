import Greeting from './components/Greeting.vue'
import TopBar from './components/navigation/TopBar.vue'
import SideNav from './components/navigation/SideNav.vue'
import ProjectGrid from './components/dashboard/ProjectGrid.vue'
import NewProjectModal from './components/projects/NewProjectModal.vue'
import NewAnalysis from './components/analyses/NewAnalysis.vue'

const components = {
  'Greeting': Greeting,
  "TopBar": TopBar,
  "SideNav": SideNav,
  "ProjectGrid": ProjectGrid,
  "NewProjectModal": NewProjectModal,
  "NewAnalysis": NewAnalysis,
}

export function getComponent(name) {
  console.log!("mounting", name)
  return components[name]
}