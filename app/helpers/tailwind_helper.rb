# Authoritative definitions for shared Tailwind styles

module TailwindHelper
  def form_classes
    "max-w-[650] mx-4 sm:mx-auto pt-8 pb-12 sm:pb-16 border shadow-xl rounded-md " \
    "bg-blue-900 border-slate-600 text-white shadow-slate-600"
  end

  def form_element_base_classes
    "block w-4/5 sm:w-full max-w-[325] mx-auto"
  end

  def form_title_classes
    "#{form_element_base_classes} mb-8 font-semibold text-center text-2xl sm:text-3xl " \
    "tracking-tight cursor-default select-none"
  end

  def form_label_classes
    "#{form_element_base_classes} text-sm select-none"
  end

  def form_input_classes
    "#{form_element_base_classes} my-1 px-2 py-1 border-2 outline-none rounded-md " \
    "bg-white disabled:bg-slate-100 text-slate-800 disabled:text-slate-500 " \
    "border-white focus:border-slate-800 disabled:border-slate-100"
  end

  def form_text_area_classes
    "#{form_input_classes} resize-none"
  end

  def form_button_classes
    "#{form_element_base_classes} my-4 px-4 py-3 font-semibold rounded-md cursor-pointer " \
    "bg-slate-800 hover:bg-slate-900 active:bg-slate-950 text-white text-sm " \
    "disabled:bg-slate-800/80 disabled:text-white/80 disabled:cursor-default"
  end
end
