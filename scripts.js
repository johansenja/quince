const callRemoteEndpoint = (endpoint, payload, selector) => {
  fetch(
    endpoint,
    {
      method: `POST`,
      headers: {
        "Content-Type": `application/json;charset=utf-8`
      },
      body: payload,
    }
  ).then(resp => resp.text()).then(html => {
    const element = document.querySelector(selector);
    if (!element) {
      throw `element not found for ${selector}`;
    }

    element.outerHTML = html
  })
}

const getFormValues = (elem) => {
  let form = elem.localName === "form" ? elem : elem.form;
  if (!form) {
    throw `element ${elem} should belong to a form`;
  }
  const fd = new FormData(form);
  return Object.fromEntries(fd.entries());
}
