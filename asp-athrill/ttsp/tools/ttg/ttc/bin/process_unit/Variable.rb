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
#  $Id: Variable.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
require "ttc/bin/class/TTCCommon.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Variable
  # ��    ��: variable�ξ����������륯�饹
  #===================================================================
  class Variable
    include TTCModule
    include TTCModule::ObjectCommon

    #=================================================================
    # ��  ��: �����ͤΥ����å�
    #=================================================================
    def check_attribute_value()
      check_attribute_type(TSR_PRM_VAR_TYPE, @sType, String, false, @aPath)
      check_attribute_type(TSR_PRM_VAR_VALUE, @snValue, [String, Integer], true, @aPath)
      if (!@hMember.nil?())
        @hMember.each_value{|val|
          check_attribute_type("member", val, [String, Integer], false, @aPath)
        }
      end
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    #=================================================================
    def object_check(bIsPre)
      check_class(Bool, bIsPre)  # pre_condition��

      aErrors = []
      # ��¤�Τξ��
      if (STR_INITIAL_INFO.has_key?(@sType))
        ### T3_VAR001: �ѿ�����¤�Τξ��ˤ��ι�¤�ΤΥ��аʳ�����Ѥ��Ƥ���
        # ����̾��������
        aMemberNames = []
        STR_INITIAL_INFO[@sType].each{|aMember|
          aMemberNames.push(aMember[0])
        }
        # �������Ƥ�����Ф����ѤǤ����Τ�
        unless (@hMember.nil?())
          @hMember.each_key{|sMember|
            unless (aMemberNames.include?(sMember))
              sErr = sprintf("T3_VAR001: " + ERR_VAR_UNDEFINED_MEMBER, sMember, @sType)
              aErrors.push(YamlError.new(sErr, @aPath))
            end
          }
        end
        ### T3_VAR003: �ѿ�����¤�Τξ���value°����������Ƥ���
        unless (@snValue.nil?())
          aErrors.push(YamlError.new("T3_VAR003: " + ERR_VAR_INVALID_DEFINE_VALUE, @aPath))
        end
      ### T3_VAR002: �ѿ����ǡ������ξ��˥��Ф�������Ƥ���
      elsif (!@hMember.nil?())
        aErrors.push(YamlError.new("T3_VAR002: " + ERR_VAR_INVALID_DEFINE_MEMBER, @aPath))
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: value��������Ƥ��뤫���֤�
    #=================================================================
    def is_value_set?()
      return !(@snValue.nil?() && @hMember.nil?())  # [Bool]value��������Ƥ��뤫
    end

    #=================================================================
    # ������: �ѿ���Υޥ�����ִ�����
    #=================================================================
    def convert_macro()
      hMacro = @cConf.get_macro()
      # ��
      @snValue = calc_all_expr(@snValue, hMacro)
      # ����
      unless (@hMember.nil?())
        @hMember.each{|sAtr, val|
          @hMember[sAtr] = calc_all_expr(@hMember[sAtr], hMacro)
        }
      end
    end

    #=================================================================
    # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
    #=================================================================
    def convert_global(hTable)
      check_class(Hash, hTable)  # �б�ɽ

      # ��
      if (@snValue.is_a?(String))
        @snValue = convert_global_params(@snValue, hTable)
      end
      # ����
      unless (@hMember.nil?())
        @hMember.each{|sAtr, val|
          if (@hMember[sAtr].is_a?(String))
            @hMember[sAtr] = convert_global_params(@hMember[sAtr], hTable)
          end
        }
      end
    end

    #=================================================================
    # ������: �䴰��¹Ԥ���
    #=================================================================
    def complement(cPrevVar)
      check_class(Variable, cPrevVar)  # ľ���ξ��֤��ѿ�

      # ������
      if (@sType.nil?())
        @sType = safe_dup(cPrevVar.sType)
      end
      # ��
      unless (is_specified?(TSR_PRM_VAR_VALUE))
        @snValue = safe_dup(cPrevVar.snValue)
      end
      # ��¤��
      if (!cPrevVar.hMember.nil?() && !@hMember.nil?())
        cPrevVar.hMember.each{|sAtr, val|
          unless (is_specified?(sAtr))
            @hMember[sAtr] = safe_dup(val)
          end
        }
      end
    end

    #=================================================================
    # ������: �����ꥢ����¹Ԥ���
    #=================================================================
    def alias(hAlias)
      check_class(Hash, hAlias)   # �����ꥢ���Ѵ��ơ��֥�

      # �ѿ�̾
      @sVarName = hAlias[@sVarName]
      # ��
      if (@snValue.is_a?(String))
        @snValue = alias_replace(@snValue, hAlias)
      end
      # ����
      unless (@hMember.nil?())
        @hMember.each{|sAtr, val|
          @hMember[sAtr] = alias_replace(val, hAlias)
        }
      end
    end

    #=================================================================
    # ������: ���֥������Ȥ�ʣ�������֤�
    #=================================================================
    def dup()
      cVar = super()

      # �ѿ�̾ʣ��
      cVar.sVarName = safe_dup(@sVarName)
      # ������ʣ��
      cVar.sType = safe_dup(@sType)
      # ��ʣ��
      cVar.snValue = safe_dup(@snValue)
      # ��¤��ʣ��
      unless (@hMember.nil?())
        hNewMember = {}
        @hMember.each{|atr, val|
          hNewMember[atr] = safe_dup(val)
        }
        cVar.hMember = hNewMember
      end

      return cVar  # [Object]ʣ���������֥�������
    end

    #=================================================================
    # ��  ��: ���֥������Ȥ����Ƥ�yaml���֥������Ȥˤ��ƽ���
    #=================================================================
    def to_yaml()
      hYaml = {}

      # ���󥹥����ѿ�
      unless (@sVarName.nil?())
        hYaml["@sVarName"] = @sVarName
      end
      # type
      hYaml[TSR_PRM_VAR_TYPE] = @sType
      # value
      if (!@snValue.nil?() || is_specified?(TSR_PRM_VAR_VALUE))
        hYaml[TSR_PRM_VAR_VALUE] = @snValue
      end
      # ��¤�ΤΥ���
      unless (@hMember.nil?())
        @hMember.each{|atr, val|
          hYaml[atr] = val
        }
      end

      return hYaml  # [Hash]YAML���֥�������
    end
  end
end
