<template>
  <el-scrollbar
    ref="scrollContainer"
    :vertical="false"
    class="scroll-container"
    @wheel.prevent="handleScroll"
  >
    <slot />
  </el-scrollbar>
</template>

<script setup>
const tagAndTagSpacing = ref(4)
const { proxy } = getCurrentInstance()

const scrollWrapper = computed(() => proxy.$refs.scrollContainer.$refs.wrapRef)

onMounted(() => {
  scrollWrapper.value.addEventListener('scroll', emitScroll, true)
})

onBeforeUnmount(() => {
  scrollWrapper.value.removeEventListener('scroll', emitScroll)
})

function handleScroll(e) {
  const eventDelta = e.wheelDelta || -e.deltaY * 40
  const $scrollWrapper = scrollWrapper.value
  $scrollWrapper.scrollLeft = $scrollWrapper.scrollLeft + eventDelta / 4
}

const emits = defineEmits()
const emitScroll = () => {
  emits('scroll')
}

function moveToTarget(currentTag) {
  const $container = proxy.$refs.scrollContainer.$el
  const $containerWidth = $container.offsetWidth
  const $scrollWrapper = scrollWrapper.value

  const tagListDom = Array.from(document.getElementsByClassName('tags-view-item'))
  if (tagListDom.length === 0) return

  const currentIndex = tagListDom.findIndex(el => el?.dataset?.path === currentTag?.path)
  if (currentIndex === -1) return

  if (currentIndex === 0) {
    $scrollWrapper.scrollLeft = 0
    return
  }

  if (currentIndex === tagListDom.length - 1) {
    $scrollWrapper.scrollLeft = $scrollWrapper.scrollWidth - $containerWidth
    return
  }

  const prevTagDom = tagListDom[currentIndex - 1]
  const nextTagDom = tagListDom[currentIndex + 1]
  if (!prevTagDom || !nextTagDom) return

  const afterNextTagOffsetLeft = nextTagDom.offsetLeft + nextTagDom.offsetWidth + tagAndTagSpacing.value
  const beforePrevTagOffsetLeft = prevTagDom.offsetLeft - tagAndTagSpacing.value
  if (afterNextTagOffsetLeft > $scrollWrapper.scrollLeft + $containerWidth) {
    $scrollWrapper.scrollLeft = afterNextTagOffsetLeft - $containerWidth
  } else if (beforePrevTagOffsetLeft < $scrollWrapper.scrollLeft) {
    $scrollWrapper.scrollLeft = beforePrevTagOffsetLeft
  }
}

defineExpose({
  moveToTarget,
})
</script>

<style lang='scss' scoped>
.scroll-container {
  white-space: nowrap;
  position: relative;
  overflow: hidden;
  width: 100%;
  :deep(.el-scrollbar__bar) {
    bottom: 0px;
  }
  :deep(.el-scrollbar__wrap) {
    height: 39px;
  }
}
</style>
