#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
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
#  $Id: Do_PostCondition.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Do_PostCondition
  # ��    ��: do��post_condition�ξ����������륯�饹
  #===================================================================
  class Do_PostCondition < Condition
    #=================================================================
    # ������: post_condition�ι�¤�����å�
    #=================================================================
    def basic_post_check(hScenarioPost)
      check_class(Hash, hScenarioPost, true)  # post_condition

      # ���֥������Ȥι�¤�����å�
      if (hScenarioPost.is_a?(Hash))
        aErrors = []
        aPath = get_condition_path()
        hScenarioPost.each{|sObjectID, hObjectInfo|
          begin
            ### T1_019: post_condition�Ǿ����Ѳ��Τʤ����֥������Ȥ����Ҥ���Ƥ���
            if (hObjectInfo.nil?())
              sErr = sprintf("T1_019: " + ERR_OBJECT_NOCHANGE, sObjectID)
              aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
            else
              common_basic_check(sObjectID, hObjectInfo, aPath)
              ### T1_020: post_condition��Υ��֥������Ȥ�type°�����������Ƥ���
              if (hObjectInfo.has_key?(TSR_PRM_TYPE))
                sErr = sprintf("T1_020: " + ERR_ONLY_PRE_ATR, TSR_PRM_TYPE)
                aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
              end
            end
          rescue TTCMultiError
            aErrors.concat($!.aErrors)
          end
        }

        check_error(aErrors)
      end
    end

    #=================================================================
    # ������: °�������å�(����°������ꤷ����������å�)
    #=================================================================
    def pre_attribute_check(hScenarioDo)
      check_class(Hash, hScenarioDo)  # do

      aPath       = get_do_path()
      aAtrDefList = get_do_attribute_list().keys()

      check_defined_attribute(hScenarioDo.keys(), aAtrDefList, aPath)
    end

    #=================================================================
    # ��  ��: °�������å�
    #=================================================================
    def attribute_check()
      aErrors = []

      aPath = get_do_path()
      # ���֥������Ȥ�°�������å�
      begin
        super()
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      ### T3_DO001: syscall��code�����ꤵ��Ƥ������ȯ�Ը����֥�������ID�����Ҥ���Ƥ��ʤ�
      if ((!@hDo[TSR_PRM_SYSCALL].nil?() || !@hDo[TSR_PRM_CODE].nil?()) && @hDo[TSR_PRM_ID].nil?())
        sErr = sprintf("T3_DO001: " + ERR_REQUIRED_KEY, TSR_PRM_ID)
        aErrors.push(YamlError.new(sErr, aPath + [TSR_PRM_ID]))
      end

      ### T2: do��°����������å�
      check_do_attribute(@hDo, @aSpecifiedDoAttributes, aPath)

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ǥ����������å�
    #=================================================================
    def condition_check()
      aErrors = []

      begin
        super()
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      # do�Υ����å�
      aPath = get_do_path()
      ### T4_036: do��code�����ꤵ��Ƥ����������ͤ����ꤵ��Ƥ���
      if (!@hDo[TSR_PRM_CODE].nil?() && exist_error_code?())
        aErrors.push(YamlError.new("T4_036: " + ERR_SET_ERRCODE_SET_CODE, aPath))
      end
      ### T4_037: do��syscall��code��Ʊ���˻��ꤵ��Ƥ���
      if (!@hDo[TSR_PRM_SYSCALL].nil?() && !@hDo[TSR_PRM_CODE].nil?())
        aErrors.push(YamlError.new("T4_037: " + ERR_SET_SYSCALL_AND_CODE, aPath))
      end

      # post_condition�Υ����å�
      aPath = get_condition_path()
      # ������롼���󡤽�λ�롼����Υ����å�
      hObjects = get_objects_by_type([TSR_OBJ_INIRTN, TSR_OBJ_TERRTN])
      hObjects.each{|sObjectID, cObjectInfo|
        ### T4_005: ������롼���󡤽�λ�롼����pre_condition�ʳ��ǻ��ꤵ��Ƥ���
        sErr = sprintf("T4_005: " + ERR_CANNNOT_DEFINED_IN_POST, cObjectInfo.sObjectType)
        aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
      }

      check_error(aErrors)
    end

    #=================================================================
    # ������: ����ǥ������������ƤΥޥ�����ִ�����
    #=================================================================
    def convert_macro()
      super()

      hMacro = @cConf.get_macro()
      @hDo.each{|sAtr, val|
        @hDo[sAtr] = calc_all_expr(@hDo[sAtr], hMacro)
      }
    end

    #=================================================================
    # ������: �䴰��¹Ԥ���
    #=================================================================
    def complement(cPrevCondition)
      check_class(Condition, cPrevCondition)  # ľ���Υ���ǥ������

      # gcov��do��������Τߡ�
      if (!@hDo.empty?() && !@aSpecifiedDoAttributes.include?(TSR_PRM_GCOV))
        @hDo[TSR_PRM_GCOV] = true
      end

      cPrevCondition.hAllObject.each{|sObjectID, cObjectInfo|
        # �䴰���ʤ����֥������Ȱʳ����䴰�¹�
        unless (GRP_NOT_COMPLEMENT_TYPE.include?(cObjectInfo.sObjectType))
          # post�˵��Ҥ���Ƥ������ά���줿°�����䴰
          unless (@hAllObject[sObjectID].nil?())
            @hAllObject[sObjectID].complement(cObjectInfo)
          # post_condition�˵��Ҥ���Ƥ��ʤ����pre_condition���饳�ԡ�
          else
            cNewObjectInfo = cObjectInfo.dup()
            cNewObjectInfo.aSpecifiedAttributes = []
            cNewObjectInfo.set_path(get_condition_path() + [cNewObjectInfo.sObjectID])
            @hAllObject[sObjectID] = cNewObjectInfo
          end
        end
      }
    end

    #=================================================================
    # ������: �����ꥢ����¹Ԥ���
    #=================================================================
    def alias(hAlias)
      check_class(Hash, hAlias)   # �����ꥢ���Ѵ��ơ��֥�

      # post_condition�Υ����ꥢ��
      super(hAlias)

      # do�Υ����ꥢ��
      @hDo.each_key{|sAtr, val|
        @hDo[sAtr] = alias_replace(@hDo[sAtr], hAlias)
      }
    end

    #=================================================================
    # ������: do�Υѥ�������֤�
    #=================================================================
    def get_do_path()
      return [@sTestID, "#{TSR_UNS_DO}#{@nSeqNum}", @nTimeTick]  # [Array]do�Υѥ�����
    end

    #=================================================================
    # ������: post_condition�Υѥ�������֤�
    #=================================================================
    def get_condition_path()
      return [@sTestID, "#{TSR_UNS_POST}#{@nSeqNum}", @nTimeTick]  # [Array]post_condition�Υѥ�����
    end

    #=================================================================
    # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
    #=================================================================
    def convert_global(hTable, hClassTable)
      check_class(Hash, hTable)       # �Ѵ��ơ��֥�
      check_class(Hash, hClassTable)  # ���饹�ִ��б�ɽ

      super(hTable, hClassTable)

      # syscall��code
      [TSR_PRM_SYSCALL, TSR_PRM_CODE].each{|sAtr|
        if (@hDo[sAtr].is_a?(String))
          @hDo[sAtr] = convert_global_params(@hDo[sAtr], hTable)
        end
      }
    end

    #=================================================================
    # ��  ��: ���顼�����ɤ����ꤵ��Ƥ��뤫���֤�
    #=================================================================
    def exist_error_code?()
      return (!@hDo[TSR_PRM_ERCD].nil?() || !@hDo[TSR_PRM_ERUINT].nil?() || !@hDo[TSR_PRM_BOOL].nil?())  # [Bool]���顼�����ɤ����ꤵ��Ƥ��뤫
    end
  end
end
