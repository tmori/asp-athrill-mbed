#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#  Copyright (C) 2012 by FUJISOFT INCORPORATED
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: TTCCommon.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
require "kconv"
require "yaml"
require "common/bin/CommonModule.rb"
require "ttc/bin/class/TTCError.rb"
require "ttc/bin/class/ObjectCommon.rb"
require "ttc/bin/kwalify.rb"
require "common/bin/Config.rb"

#=====================================================================
# TTCModule
#=====================================================================
module TTCModule
  include CommonModule

  #===================================================================
  # ������: YAML�ե��������ɤ���
  #===================================================================
  def load_yaml_file(sFileName)
    check_class(String, sFileName)  # �ե�����̾

    cConf = Config.new()
    begin
      if (cConf.use_yaml_library?())
        yaml = YAML.load(File.read(sFileName).toutf8)
      else
        yaml = Kwalify::Yaml.load_file(sFileName)
       end
    rescue SystemCallError
      raise(TTCError.new(sprintf(ERR_CANNOT_OPEN_FILE, sFileName) + "#{TTG_NL}(#{$!.message()})"))
    rescue ArgumentError
      raise(TTCError.new(sprintf(ERR_YAML_SYNTAX_INVALID, sFileName) + "#{TTG_NL}(#{$!.message()})"))
    rescue Kwalify::SyntaxError
      raise(TTCError.new(sprintf(ERR_YAML_SYNTAX_INVALID, sFileName) + "#{TTG_NL}(#{$!.message()})"))
    end

    return yaml  # [Object]YAML���֥�������
  end
  protected :load_yaml_file

  #===================================================================
  # ������: �ͤ�黻����
  #===================================================================
  def parse_value(val, hMacro = {})
    check_class(Object, val, true)  # ��
    check_class(Hash, hMacro)       # �ޥ���

    # ʸ����ξ����͡��ʥ��������б�
    if (val.is_a?(String))
      result = val.dup()
      # �桼������ޥ�����ִ�
      unless (hMacro.empty?())
        aMatches = val.scan(/\w+/)
        aMatches.each{|sMacro|
          if (hMacro.has_key?(sMacro))
            result = result.gsub(/(^|\W)#{sMacro}(?=$|\W)/, "\\1#{hMacro[sMacro]}")
          end
        }
      end

      # ���͡�16�ʿ���ˤȰ����ε���ȶ���Τߤǹ������줿ʸ����
      if (result =~ /^(\d+|0x[a-fA-F\d]+|[\s\+\-\*\/\|\&\(\)])+$/)
        begin
          result = eval(result)
        rescue SyntaxError
          sErr = sprintf(ERR_EXPRESSION_INVALID, result)
          raise(TTCError.new(sErr))
        end
      end
    # ʸ����ʳ��ξ��Ϥ��Τޤ�
    else
      result = safe_dup(val)
    end

    return result  # [Object]�黻���
  end

  #===================================================================
  # ������: �ޥ����ִ����׻����α黻��Ԥ�
  #===================================================================
  def calc_all_expr(data, hMacro)
    check_class(Object, data, true)  # ��
    check_class(Hash, hMacro)        # �ޥ���

    if (data.is_a?(Hash))
      hTmp = data
      data = {}
      hTmp.each{|atr, val|
        atr       = parse_value(atr, hMacro)
        val       = calc_all_expr(val, hMacro)
        data[atr] = val
      }
    elsif (data.is_a?(Array))
      data = data.dup()
      data.each_with_index{|val, index|
        data[index] = calc_all_expr(val, hMacro)
      }
    elsif (data.is_a?(String))
      data = parse_value(data, hMacro)
    end

    return data  # [Object]�ޥ����ִ����׻����α黻�η��
  end

  #===================================================================
  # ������: ʸ����򸡺������ƥ���ID����Ϳ�Ǥ��������Ƥ򥨥��ꥢ��
  #       : ʸ����ʳ��ξ��Ϥ��Τޤ��֤�
  #===================================================================
  def alias_replace(sStr, hAlias)
    check_class(Object, sStr)  # �о�ʸ����
    check_class(Hash, hAlias)  # �����ꥢ���Ѵ��ơ��֥�

    if (sStr.is_a?(String))
      sResult = sStr.dup()
      aMatches = sResult.scan(/\w+/)
      aMatches.each{|sMatch|
        # �֤������о�ID�˴ޤޤ����ϥ����ꥢ��
        if (hAlias.has_key?(sMatch))
          sAlias  = hAlias[sMatch]
          sResult = sResult.gsub(/(^|\W)#{sMatch}(?=$|\W)/, "\\1#{sAlias}")
        end
      }
      return sResult  # [Object]�ƥ���ID����Ϳ���줿ʸ����
    else
      return safe_dup(sStr)  # ���Υ��֥�������
    end
  end

  #===================================================================
  # ������: ʸ����˥ƥ���ID����Ϳ�����֤�
  #===================================================================
  def alias_str(sStr, sTestID)
    check_class(String, sStr)     # �о�ʸ����
    check_class(String, sTestID)  # �ƥ���ID

    return "#{sTestID}_#{sStr}"  # [String]�ƥ���ID����Ϳ���줿ʸ����
  end

  #===================================================================
  # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
  #===================================================================
  def convert_global_params(sStr, hTable)
    check_class(String, sStr)  # �о�ʸ����
    check_class(Hash, hTable)  # �Ѵ�ɽ

    sResult = ""  # �Ѵ����ʸ����
    aList = sStr.split(/(\w+)/)
    aList.each{|val|
      case val
      when CFG_MCR_REX_PRCID
        val = convert_global_prcid(val, hTable)
      when CFG_MCR_REX_INTNO
        val = convert_global_intno(val, hTable)
      when CFG_MCR_REX_INHNO
        val = convert_global_inhno(val, hTable)
      when CFG_MCR_REX_EXCNO
        val = convert_global_excno(val, hTable)
      end
      sResult.concat(val)
    }

    return sResult  # [String]�Ѵ����ʸ����
  end

  #===================================================================
  # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���prcid��
  #===================================================================
  def convert_global_prcid(sMacro, hTable)
    check_class(String, sMacro)  # �ޥ���
    check_class(Hash, hTable)    # �Ѵ�ɽ

    lPrevKey = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_PRCID][:local].index(sMacro)
    lConvKey = hTable[lPrevKey]
    unless (lConvKey.nil?())
      sGlobal =  TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_PRCID][:global][lConvKey]
    else
      sGlobal = sMacro.dup()
    end

    return sGlobal  # [String]�Ѵ���Υѥ�᡼��
  end

  #===================================================================
  # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���intno��
  #===================================================================
  def convert_global_intno(sMacro, hTable)
    check_class(String, sMacro)  # �ޥ���
    check_class(Hash, hTable)    # �Ѵ�ɽ

    sGlobal = sMacro.dup()
    if (sMacro =~ CFG_MCR_REX_INTNO)
      case $3
      when "INVALID"
        hTempHash = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INTNO_INVALID][:local].invert()
        lPrevKey = hTempHash[$1]
        lConvKey = hTable[lPrevKey]
        unless (lConvKey.nil?())
          sGlobal = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INTNO_INVALID][:global][lConvKey]
        end
      when "NOT_SET"
        hTempHash = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INTNO_NOT_SET][:local].invert()
        lPrevKey = hTempHash[$1]
        lConvKey = hTable[lPrevKey]
        unless (lConvKey.nil?())
          sGlobal = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INTNO_NOT_SET][:global][lConvKey]
        end
      else
        hTempHash = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INTNO_PREFIX][:local].invert()
        lPrevKey = hTempHash[$1]
        lConvKey = hTable[lPrevKey]
        unless (lConvKey.nil?())
          sGlobal = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INTNO_PREFIX][:global][lConvKey] + $6
        end
      end
    end

    return sGlobal  # [String]�Ѵ���Υѥ�᡼��
  end

  #===================================================================
  # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���inhno��
  #===================================================================
  def convert_global_inhno(sMacro, hTable)
    check_class(String, sMacro)  # �ޥ���
    check_class(Hash, hTable)    # �Ѵ�ɽ

    sGlobal = sMacro.dup()
    if (sMacro =~ CFG_MCR_REX_INHNO)
      hTempHash = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INTNO_PREFIX][:local].invert()
      lPrevKey = hTempHash[$1]
      lConvKey = hTable[lPrevKey]
      unless (lConvKey.nil?())
        sGlobal = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_INHNO_PREFIX][:global][lConvKey] + $4
      end
    end

    return sGlobal  # [String]�Ѵ���Υѥ�᡼��
  end

  #===================================================================
  # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���excno��
  #===================================================================
  def convert_global_excno(sMacro, hTable)
    check_class(String, sMacro)  # �ޥ���
    check_class(Hash, hTable)    # �Ѵ�ɽ

    sGlobal = sMacro.dup()

    hTempHash = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_EXCNO][:local].invert()
    lPrevKey = hTempHash[sMacro]
    lConvKey = hTable[lPrevKey]
    unless (lConvKey.nil?())
      sGlobal = TTC_GLOBAL_TABLE[TTC_GLOBAK_KEY_EXCNO][:global][lConvKey]
    end

    return sGlobal  # [String]�Ѵ���Υѥ�᡼��
  end

  #===================================================================
  # ������: ����ǥ�������ʬ�Ϥ�������ƥ��å�����Ĥ�Ƚ�ꤷ���֤�
  #===================================================================
  def has_timetick?(hCondition)
    check_class(Object, hCondition, true)  # do��post_condition

    bResult = false
    if (hCondition.is_a?(Hash))
      cConf   = Config.new()
      hMacro  = cConf.get_macro()
      bResult = hCondition.all?(){|key, val|
        key = parse_value(key, hMacro)
        key.is_a?(Integer)
      }
    end

    return bResult  # [Bool]������ƥ��å�����ľ��true�������Ǥʤ����false
  end

  #===================================================================
  # ������: ���顼�����뤫�����å�������������㳰���ꤲ��
  #===================================================================
  def check_error(aErrors)
    check_class(Array, aErrors)  # ���顼��Ǽ����

    # ���顼�����ä����
    unless (aErrors.empty?())
      raise(TTCMultiError.new(aErrors))
    end
  end

  #===================================================================
  # ������: °�����������Ƥ����Τ������å�
  #===================================================================
  def check_defined_attribute(aAtrs, aAtrList, aPath)
    check_class(Array, aAtrs)     # ���Ҥ��줿°��
    check_class(Array, aAtrList)  # ����Ǥ���°��
    check_class(Array, aPath)     # �롼�Ȥ���Υѥ�

    aErrors = []
    ### T1_022: ���֥������Ȥ������ǽ��°���ʳ������ꤵ��Ƥ���
    aAtrs.each{|sAtr|
      unless (aAtrList.include?(sAtr))
        sErr = sprintf("T1_022: " + ERR_UNDEFINED_KEY, sAtr)
        aErrors.push(YamlError.new(sErr, aPath))
      end
    }

    check_error(aErrors)
  end

  #===================================================================
  # ������: °���Υ��饹�����ץ����å�
  #===================================================================
  def check_attribute_type(sAtr, val, acClass, bAllowNil, aPath)
    check_class(String, sAtr)             # °��̾
    check_class(Object, val, true)        # �����å�������
    check_class([Class, Array], acClass)  # ���������饹
    check_class(Bool, bAllowNil)          # nil����Ĥ��뤫
    check_class(Array, aPath)             # �롼�Ȥ���Υѥ�

    bMatch = false
    # ���ꤵ�줿���饹�������å�
    unless (acClass.is_a?(Array))
      acClass = [acClass]
    end
    # nil����
    if (bAllowNil == true)
      acClass.push(NilClass)
    end
    acClass.each{|cClass|
      if (val.is_a?(cClass))
        bMatch = true
        break
      end
    }

    ### T2_001: �ѥ�᡼���η������ꤵ��Ƥ��뷿�Ȱۤʤ�
    if (bMatch == false)
      sErr = sprintf("T2_001: " + ERR_INVALID_TYPE, sAtr, acClass.join(" or "), val.class())
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: °�����ͤ�0�ʾ�������������å�
  #===================================================================
  def check_attribute_unsigned(sAtr, val, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    check_attribute_type(sAtr, val, Integer, false, aPath)
    # ���
    if (val < 0)
      sErr = sprintf("T2_002: " + ERR_BE_INTEGER_GE, sAtr, 0, val)
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: °�����ͤ����ꤷ�����ͤ���礭�������������å�
  #===================================================================
  def check_attribute_gt(sAtr, val, nComp, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������
    check_class(Integer, nComp)     # ��Ӥ������
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    check_attribute_type(sAtr, val, Integer, false, aPath)
    # ���
    if (val <= nComp)
      sErr = sprintf("T2_002: " + ERR_BE_INTEGER_GT, sAtr, nComp, val)
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: °�����ͤ����ꤷ�����Ͱʲ��������������å�
  #===================================================================
  def check_attribute_le(sAtr, val, nComp, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������
    check_class(Integer, nComp)     # ��Ӥ������
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    check_attribute_type(sAtr, val, Integer, false, aPath)
    # ���
    if (val > nComp)
      sErr = sprintf("T2_002: " + ERR_BE_INTEGER_LE, sAtr, nComp, val)
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: °�����ͤ����ꤷ�����ͤ�꾮���������������å�
  #===================================================================
  def check_attribute_lt(sAtr, val, nComp, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������
    check_class(Integer, nComp)     # ��Ӥ������
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    check_attribute_type(sAtr, val, Integer, false, aPath)
    # ���
    if (val >= nComp)
      sErr = sprintf("T2_002: " + ERR_BE_INTEGER_LT, sAtr, nComp, val)
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: °�����ͤ��ϰ���������������å�
  #===================================================================
  def check_attribute_range(sAtr, val, nMin, nMax, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������
    check_class(Integer, nMin)      # �Ǿ���
    check_class(Integer, nMax)      # ������
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    check_attribute_type(sAtr, val, Integer, false, aPath)
    # ���
    unless (val >= nMin && val <= nMax)
      sErr = sprintf("T2_002: " + ERR_BE_INTEGER_RANGE, sAtr, nMin, nMax, val)
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: °�����ͤ�ͽ�����줿�ͤ������å�
  #===================================================================
  def check_attribute_enum(sAtr, val, aEnum, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������
    check_class(Array, aEnum)       # ͽ�����줿��
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    unless (aEnum.include?(val))
      sErr = sprintf("T2_002: " + ERR_BE_INCLUDE, sAtr, aEnum.join(" | "), val)
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: °�����ͤ�ͽ�����줿�͡��ޤ��Ϥ����Ȥ߹�碌�������å�
  #===================================================================
  def check_attribute_multi(sAtr, val, aEnum, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������
    check_class(Array, aEnum)       # ͽ�����줿��
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    val = val.gsub(/\s+/, "")
    val = val.gsub(/^\((.*)\)$/, "\\1")
    aMacro = val.split("|")
    aMacro.each{|sMacro|
      begin
        check_attribute_enum(sAtr, sMacro, aEnum, aPath)
      rescue YamlError
        sErr = sprintf("T2_002: " + ERR_BE_INCLUDE, sAtr, aEnum.join(" | "), val)
        raise(YamlError.new(sErr, aPath + [sAtr]))
      end
    }
  end

  #===================================================================
  # ������: °�����ͤ��ѿ�̾�������å�
  #===================================================================
  def check_attribute_variable(sAtr, val, aPath)
    check_class(String, sAtr)       # °��̾
    check_class(Object, val, true)  # �����å�������(T2_001�ǥ����å���Ԥ�)
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    check_attribute_type(sAtr, val, String, false, aPath)
    ### T2_003: �ѿ�̾��̿̾��§��ȿ���Ƥ���
    unless (val =~ TSR_REX_VARIABLE)
      sErr = sprintf("T2_003: " + ERR_INVALID_VAR_NAME, val)
      raise(YamlError.new(sErr, aPath + [sAtr]))
    end
  end

  #===================================================================
  # ������: do��°�������å�
  #===================================================================
  def check_do_attribute(hDo, aSpecified, aPath)
    check_class(Hash, hDo)          # �����å�������
    check_class(Array, aSpecified)  # ���ꤵ�줿°��
    check_class(Array, aPath)       # �롼�Ȥ���Υѥ�

    aErrors = []
    ### T2: do��°����������å�
    hDefs = get_do_attribute_list()
    hDefs.each{|sAtr, aClass|
      if (aSpecified.include?(sAtr))
        cClass = hDo[sAtr].class()
        unless (aClass.include?(cClass))
          sErr = sprintf("T2_001: " + ERR_INVALID_TYPE, sAtr, aClass.join(" or "), cClass)
          aErrors.push(YamlError.new(sErr, aPath + [sAtr]))
        end
      end
    }

    check_error(aErrors)
  end

  #===================================================================
  # ������: do��°��������������
  #===================================================================
  def get_do_attribute_list()
    # �ץ�ե�������б�����°��������������
    cConf = Config.new()
    if (cConf.is_asp?())
      aResult = GRP_DEF_DO_ASP
    elsif (cConf.is_fmp?())
      aResult = GRP_DEF_DO_FMP
    else
      abort(ERR_MSG % [__FILE__, __LINE__])
    end

    return aResult.dup()  # [Array]do��°���������
  end
end
